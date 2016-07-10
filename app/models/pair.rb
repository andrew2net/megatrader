class Pair < ActiveRecord::Base
  belongs_to :time_frame
  belongs_to :left_tool_symbol, class_name: 'ToolSymbol',
    foreign_key: :tool_symbol_1_id, inverse_of: :left_pairs
  belongs_to :right_tool_symbol, class_name: 'ToolSymbol',
    foreign_key: :tool_symbol_2_id, inverse_of: :right_pairs

  # Return data for pairs charts. If passed one symbol, the function return
  # charts for all possible pairs for the symbol. If passed more then one symbols
  # then return charts for paisr with only passed symbols.
  #
  # time_frame - string name of time frame.
  # symbols - array of string symbol names.
  # page - nuber of page to display.
  #
  # Return hash {charts, total} where charts is data for current page and
  # total is number of all charts.
  def self.get_pairs(time_frame, symbols, page)
    t_f = TimeFrame.find_by name: time_frame
    symbol_ids = Spread.select(:tool_symbol_id).distinct
      .where(tool_symbol_id: symbols, time_frame_id: t_f.id).pluck :tool_symbol_id

    # Query possyble charts.
    charts_all = if symbols.size > 1
                   where({tool_symbol_1_id: symbol_ids,
                          tool_symbol_2_id: symbol_ids})
                 else
                   where('tool_symbol_1_id=:sym OR tool_symbol_2_id=:sym',
                         {sym: symbol_ids})
                 end
    charts_all = charts_all.where(time_frame_id: t_f.id).reorder(fitness: :desc)

    # Make data charts for passed page.
    charts = charts_all.page(page).per(10).map do |pair|
      chart_data = Spread.chart_data t_f, {
        pair.tool_symbol_1_id.to_s => pair.weight_1.to_s,
        pair.tool_symbol_2_id.to_s => pair.weight_2.to_s
      }, 400
      {
        symbols: [
          {symbol: pair.left_tool_symbol.name, weight: pair.weight_1},
          {symbol: pair.right_tool_symbol.name, weight: pair.weight_2}
        ],
        data: chart_data
      }
    end.select {|el| el[:data]} # Remove empty charts.

    { charts: charts, total: charts_all.count }
  end
end
