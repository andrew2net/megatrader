class Pair < ActiveRecord::Base
  belongs_to :time_frame
  belongs_to :left_tool_symbol, class_name: 'ToolSymbol',
    foreign_key: :tool_symbol_1_id, inverse_of: :left_pairs
  belongs_to :right_tool_symbol, class_name: 'ToolSymbol',
    foreign_key: :tool_symbol_2_id, inverse_of: :right_pairs

  def self.get_pairs(time_frame, symbols, page)
    t_f = TimeFrame.find_by name: time_frame
    symbol_ids = Spread.select(:tool_symbol_id).distinct
      .where(tool_symbol_id: symbols, time_frame_id: t_f.id)
    charts_all = where({time_frame_id: t_f.id, tool_symbol_1_id: symbol_ids,
      tool_symbol_2_id: symbol_ids}).order(fitness: :desc)
    charts = charts_all.page(page).per(1).map do |pair|
      chart_data = Spread.chart_data t_f, {
        pair.tool_symbol_1_id.to_s => pair.weight_1.to_s,
        pair.tool_symbol_2_id.to_s => pair.weight_2.to_s
      }
      {
        symbols: [
          {symbol: pair.left_tool_symbol.name, weight: pair.weight_1},
          {symbol: pair.right_tool_symbol.name, weight: pair.weight_2}
        ],
        data: chart_data
      }
    end.select {|el| el[:data]}
    { charts: charts, total: charts_all.count }
  end
end
