class Correlation < ActiveRecord::Base
  belongs_to :row_tool_symbol, class_name: 'ToolSymbol'
  belongs_to :col_tool_symbol, class_name: 'ToolSymbol'
  belongs_to :time_frame
  validates :time_frame_id, uniqueness: {scope: [:row_tool_symbol_id, :col_tool_symbol_id]}
  validates :time_frame_id, :row_tool_symbol_id, :col_tool_symbol_id, presence: true
end
