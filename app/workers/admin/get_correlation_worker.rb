class Admin::GetCorrelationWorker
  include Sidekiq::Worker

  def perform(*args)
    tools = ToolSymbol.pluck(:name).join ','
    TimeFrame.all.each do |t|
      resp = Faraday.post 'http://94.180.118.28:4100',
        {Symbols: tools, TimeFrame: t.name, ReqType: 2}
      correlations = JSON.parse(resp.body)['Correlation']
      correlations.each do |c|
        next if c[0] == c[1]
        row_symbol = ToolSymbol.find_by name: c[0]
        unless row_symbol
          p "#{c[0]} not found"
          next
        end
        col_symbol = ToolSymbol.find_by name: c[1]
        unless col_symbol
          p "#{c[1]} not found"
          next
        end
        correlation = Correlation.find_by time_frame_id: t.id,
          row_tool_symbol_id: col_symbol.id,
          col_tool_symbol_id: row_symbol.id
        unless correlation
          correlation = Correlation.find_or_create_by time_frame_id: t.id,
            row_tool_symbol_id: row_symbol.id,
            col_tool_symbol_id: col_symbol.id
        end
        correlation.update value: c[2]
      end
    end
  end
end
