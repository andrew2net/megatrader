class Admin::GetPairsWorker
  include Sidekiq::Worker

  def perform(*args)
    tools = ToolSymbol.pluck(:name).join ','
    TimeFrame.all.each do |t|
      resp = Faraday.post 'http://94.180.118.28:4100',
        {Symbols: tools, TimeFrame: t.name, ReqType: 3}
      pairs = JSON.parse(resp.body)['Pairs']
      pairs.each do |p|
        next if p[0] == p[1]
        symbol_1 = ToolSymbol.find_by name: p[0]
        unless symbol_1
          p "#{p[0]} not found"
          next
        end
        symbol_2 = ToolSymbol.find_by name: p[1]
        unless symbol_2
          p "#{p[1]} not found"
          next
        end
        pair = Pair.find_by time_frame_id: t.id,
          tool_symbol_1_id: symbol_1.id,
          tool_symbol_2_id: symbol_2.id
        unless pair
          pair = Pair.find_or_create_by time_frame_id: t.id,
            tool_symbol_1_id: symbol_2.id,
            tool_symbol_2_id: symbol_1.id
        end
        pair.update weight_1: p[2].round(2), weight_2: p[3].round(2), fitness: p[4]
      end
    end
  end
end
