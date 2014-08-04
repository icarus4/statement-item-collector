# Join model for Item and Statement
class ItemStatementPair < ActiveRecord::Base
  belongs_to :item
  belongs_to :statement
end
