class Admin::GetToolsWorker
  include Sidekiq::Worker

  def perform(*args)
    resp = Faraday.post 'http://94.180.118.28:4100', ReqType: 4
    tools = JSON.parse resp.body
    tools['SymbolList'].each do |s|
      group = ToolGroup.find_or_create_by name: s[2]
      sym = ToolSymbol.find_or_create_by name: s[0]
      sym.tool_group = group
      sym.update full_name: s[1]
      if s[2] == 'Forex'
        group.update position: 1
      end
    end
    n = 1
    ToolGroup.where(position: nil).each do |g|
      n = n + 1
      g.update position: n
    end
  end
end
