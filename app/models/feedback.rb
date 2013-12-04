class Feedback < ActiveRecord::Base
  self.inheritance_column = nil #needed to use 'type' column with ActiveRecord
end
