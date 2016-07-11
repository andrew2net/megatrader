class Application::ApiController < ApplicationController
  skip_before_action :authenticate

  def tools
    g = ToolGroup.order(:position).select :id, :name
    t = ToolSymbol.joins(:tool_group).reorder('position, tool_symbols.name')
      .select(%{ tool_symbols.id, tool_symbols.name, tool_symbols.full_name,
    tool_group_id g_id })
    render json: { groups: g, tools: t }
  end

  def correlations
    time_frame = TimeFrame.find_by name: params[:timeFrame]
    sql = %{
    SELECT row_tool_symbol_id r, col_tool_symbol_id c, value, weight_1, weight_2,
    tr.name symbol_1, tc.name symbol_2
    FROM correlations cr
    LEFT JOIN pairs p ON
      p.tool_symbol_1_id IN (row_tool_symbol_id,col_tool_symbol_id) AND
      p.tool_symbol_2_id IN (row_tool_symbol_id,col_tool_symbol_id)
    JOIN tool_symbols tr ON tr.id=row_tool_symbol_id
    JOIN tool_symbols tc ON tc.id=col_tool_symbol_id
    WHERE cr.time_frame_id=:time_frame_id}
    query = ActiveRecord::Base.send('sanitize_sql_array',
                                    [sql, {time_frame_id: time_frame.id}])
    correlations = {}
    # Correlation.select('row_tool_symbol_id r, col_tool_symbol_id c, value')
    #   .where(time_frame_id: time_frame.id).each do |corr|
    ActiveRecord::Base.connection.send('select_all', query).each do |corr|
      # s_ids = [corr.r, corr.c]
      # pair = Pair.where(time_frame_id: time_frame.id, tool_symbol_1_id: s_ids,
      #           tool_symbol_2_id: s_ids).first
      correlations[corr['r']] = {} unless correlations[corr['r']]
      d = { value: corr['value'] }
      d.merge!({
        symbol_1: corr['symbol_1'],
        weight_1: corr['weight_1'],
        symbol_2: corr['symbol_2'],
        weight_2: corr['weight_2']
      }) # if pair
      correlations[corr['r']][corr['c']] = d
    end
    render json: correlations
  end

  def tool_symbols
    tool_sybols = ToolSymbol.pluck :name
    render json: tool_sybols
  end

  def spread
    time_frame = TimeFrame.find_by name: params[:time_frame]
    if result = Spread.chart_data(time_frame, params[:symbols])
      render json: result
    else
      render nothing: true
    end
  end

  def pairs
    render json: Pair.get_pairs(params[:time_frame], params[:symbols],
                                params[:page])
  end
end
