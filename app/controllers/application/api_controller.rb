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
    correlations = {}
    Correlation .select('row_tool_symbol_id r, col_tool_symbol_id c, value')
      .where(time_frame_id: time_frame.id).each do |corr|
      correlations[corr.r] = {} unless correlations[corr.r]
      correlations[corr.r][corr.c] = corr.value
    end
    render json: correlations
  end

  def tool_symbols
    tool_sybols = ToolSymbol.pluck :name
    render json: tool_sybols
  end
end
