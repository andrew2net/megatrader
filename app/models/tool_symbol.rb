class ToolSymbol < ActiveRecord::Base
  default_scope {reorder(:name)}
  has_many :correlation_rows, class_name: 'Correlation',
    foreign_key: 'row_tool_symbol_id', dependent: :delete_all
  has_many :correlation_cols, class_name: 'Correlation',
    foreign_key: 'col_tool_symbol_id', dependent: :delete_all
  belongs_to :tool_group
  has_many :left_pairs, inverse_of: :right_tool_symbol
  has_many :right_pairs, inverse_of: :left_tool_symbol
end
