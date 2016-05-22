class Admin::GetSpreadWorker
  include Sidekiq::Worker

  def perform(*args)

    # Check if spread shoul be reloaded.
    reload_setting = Setting.find_by(name: 'reload_spread')
    reload = reload_setting.value.downcase == 'yes' if reload_setting
    # Spread.delete_all if reload

    TimeFrame.all.each do |t|
      days_ago = Setting.find_by(name: t.name + '_period').value.to_i * 2
      first_date = ( Date.today - days_ago ).strftime '%Y%m%d'

      # Retrieve new data add it to db.
      ToolSymbol.all.each do |s|
        ActiveRecord::Base.transaction do
          req_params = {
            Symbols: s.name,
            TimeFrame: t.name,
            Weights: 1,
            Epsilon: 0
          }
          if reload
            req_params.merge! DateFrom: first_date
          else
            last_date = Spread.select(:date_time)
              .where(time_frame_id: t.id, tool_symbol_id: s.id)
              .order(:date_time).last
            if last_date
              date_from = last_date.date_time.strftime '%Y%m%d'
              time_from = last_date.date_time.strftime '%H%M%S'
              req_params.merge! DateFrom: date_from, TimeFrom: time_from
            else
              req_params.merge! DateFrom: first_date
            end
          end
          resp = Faraday.post 'http://94.180.118.28:4100', req_params
          spread = JSON.parse(resp.body)['Chart']
          values = spread.map do |c|
            v = c[0]
            d = DateTime.strptime c[1], '%d%m%Y%H%M' # ddMMyyyyhhmm
            "(#{t.id}, #{s.id}, '#{d.strftime '%Y-%m-%d %H:%M:%S'}'::timestamp,
            #{v})"
          end
          ActiveRecord::Base.connection.execute %{
          WITH new_values (time_frame_id, tool_symbol_id, date_time, value) AS (
            values #{values.join ','}
          ),
          upsert AS (
            update spreads s SET value=nv.value FROM new_values nv
            WHERE s.time_frame_id=nv.time_frame_id
              AND s.tool_symbol_id=nv.tool_symbol_id
              AND s.date_time=nv.date_time
            RETURNING s.*
          )
          INSERT INTO spreads (time_frame_id, tool_symbol_id, date_time, value)
          SELECT time_frame_id, tool_symbol_id, date_time, value FROM new_values v
          WHERE NOT EXISTS (SELECT 1 FROM upsert AS up
            WHERE up.time_frame_id=v.time_frame_id
              AND up.tool_symbol_id=v.tool_symbol_id
              AND up.date_time=v.date_time)
          } unless values.blank?
        end
      end

      # Remove old data.
      Spread.where('time_frame_id=:t_id AND date_time<:date',
                   t_id: t.id, date: first_date).delete_all
    end
    reload_setting.update value: 'no' if reload
  end
end
