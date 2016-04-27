class Admin::GetSpreadWorker
  include Sidekiq::Worker

  def perform(*args)
    TimeFrame.all.each do |t|
      ToolSymbol.all.each do |s|
        req_params = { Symbols: s.name, TimeFrame: t.name, Weights: 1, Epsilon: 0 }
        last_date = Spread.select(:date_time)
          .where(time_frame_id: t.id, tool_symbol_id: s.id).order(:date_time).last
        if last_date
          date_from = last_date.date_time.strftime '%Y%m%d'
          time_from = last_date.date_time.strftime '%H%M%S'
          req_params.merge! DateFrom: date_from, TimeFrom: time_from
        end
        resp = Faraday.post 'http://94.180.118.28:4100', req_params
        spread = JSON.parse(resp.body)['Chart']
        spread.each do |c|
          v = c[0]
          d = DateTime.strptime c[1], '%d%m%Y%H%M' # ddMMyyyyhhmm
          sprd = Spread.find_or_create_by time_frame_id: t.id,
            tool_symbol_id: s.id, date_time: d
          sprd.update value: v
        end
      end
    end
  end
end
