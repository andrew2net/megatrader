class Correlation < ActiveRecord::Base
  belongs_to :row_tool_symbol, class_name: 'ToolSymbol'
  belongs_to :col_tool_symbol, class_name: 'ToolSymbol'
end
