class Spread < ActiveRecord::Base
  belongs_to :tool_symbol
  belongs_to :time_frame
end
