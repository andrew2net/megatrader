class ToolSymbol < ActiveRecord::Base
  default_scope {reorder(:name)}
  has_many :correlation_rows, class_name: 'Correlation',
    foreign_key: 'row_tool_symbol_id'
  has_many :correlation_cols, class_name: 'Correlation',
    foreign_key: 'col_tool_symbol_id'
  belongs_to :tool_group
end
