require "#{Rails.root}/lib/chart/chart"
class Spread < ActiveRecord::Base
  belongs_to :tool_symbol
  belongs_to :time_frame

  class << self
    def chart_data(time_frame, symbols, max_points = 1200)
      return false unless symbols
      days = Setting.find_by(name: time_frame.name + '_period').value
      date_time = (Date.today - days.to_i)
      spread = nil
      join = ''
      sw = []
      ToolSymbol.where(id: symbols.map{|k, v| k}).each do |s|
        w = symbols[s.id.to_s].gsub(',', '.').to_f
        next if w == 0
        w = w.to_s
        if spread
          sw << s.name + '.value*' + w
          join = join + %{
          JOIN spreads #{s.name} ON #{s.name}.date_time=s.date_time
          AND #{s.name}.time_frame_id=s.time_frame_id
          AND #{s.name}.tool_symbol_id=#{s.id}}
        else
          sw << 's.value*' + w
          spread = %{FROM spreads s joins WHERE s.date_time>=:date_time AND
          s.time_frame_id=:time_frame_id AND s.tool_symbol_id=#{s.id}
          ORDER BY s.date_time}
        end
      end
      if spread
        spread = %{ SELECT #{sw.join '+'}, to_char(s.date_time, 'DDMMYYYYHH24MI')
        #{spread.sub 'joins', join.to_s}}
        sql = ActiveRecord::Base.send(
          :sanitize_sql_array,
          [spread, {date_time: date_time, time_frame_id: time_frame.id}])
        data = ActiveRecord::Base.connection.select_rows sql
        if data.empty?
          false
        elsif data.size > max_points
          points = data.map{|p| p[0].to_f}
          points_ptr = FFI::MemoryPointer.new :double, data.size
          points_ptr.put_array_of_double 0, points
          e = 0.01
          begin
            keep_ptr = Chart.CompressChart points_ptr, data.size, e
            keep = keep_ptr.read_array_of_uint data.size
            p = keep.select{|v| v == 1}
            e = e + 0.01
          end while p.size > max_points
          keep.each_with_index{|v, i| if v == 0 then data[i] = nil end}
          data.compact
        else
          data
        end
      else
        false
      end
    end

    private

    def get_seg_dist(x, y, x1, y1, x2, y2)
      v=(x-x1)*(y2-y1)-(y-y1)*(x2-x1)
      v*v/((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
    end

    def compress_chart(data, epsilon = 0.02)
      count = data.size
      left_ind = []
      right_ind = []
      intervals = 0
      left_ind[intervals] = 0
      right_ind[intervals] = count - 1
      intervals = intervals + 1
      min, max = data.minmax_by{|el| el[0].to_f}.map{|el| el[0].to_f}
      epsilon = (max - min) * epsilon
      epsilon = epsilon * epsilon;

      while intervals > 0 do
        intervals = intervals - 1
        start = left_ind[intervals]
        dest = right_ind[intervals]
        d_max = 0
        index = start
        ((start+1)...dest).each do |i|
          unless data[i].nil?
            d = get_seg_dist(i, data[i][0].to_f, start, data[start][0].to_f, dest,
                             data[dest][0].to_f)
            if d > d_max
              index = i
              d_max = d
            end
          end
        end
        if d_max >= epsilon
          left_ind[intervals] = start
          right_ind[intervals] = index
          intervals = intervals + 1
          left_ind[intervals] = index
          right_ind[intervals] = dest
          intervals = intervals + 1
        else
          ((start+1)...dest).each do |j|
            data[j] = nil
          end
        end
      end
      data.compact
    end
  end
end
