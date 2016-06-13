class Pair < ActiveRecord::Base
  belongs_to :time_frame
  belongs_to :tool_symbol_1, class_name: 'ToolSymbol'
  belongs_to :tool_symbol_2, class_name: 'ToolSymbol'
end
