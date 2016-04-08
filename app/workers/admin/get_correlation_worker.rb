class Admin::GetCorrelationWorker
  include Sidekiq::Worker

  def perform(*args)
    ToolSymbol.all.each do |s|
      response = Faraday.post 'http://94.180.118.28:4100',
        {Symbols: s.name, TimeFrame: 'h1', ReqType: 2}
      correlations = JSON.parse(response.body)['Correlation']
      correlations.each do |c|
        row_symbol = ToolSymbol.find_or_create_by name: c[0]
        col_symbol = ToolSymbol.find_or_create_by name: c[1]
        correlation = Correlation.find_or_create_by row_tool_symbol_id: row_symbol.id,
          col_tool_symbol_id: col_symbol.id
        correlation.update value: c[2]
      end
    end
  end
end
