class Application::ApiController < ApplicationController
  skip_before_action :authenticate
  def get_correlations
    correlations = {}
    correlations[:cols] = ToolSymbol.pluck :name
    correlations[:rows] = ToolSymbol.all.map do |r|
      row = {name: r.name}
      ToolSymbol.all.each do |c|
        correlation = Correlation.find_by row_tool_symbol_id: r.id, col_tool_symbol_id: c.id
        row[c.name] = correlation.value if correlation
      end
      row
    end
    render json: correlations
  end
end
