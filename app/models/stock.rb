class Stock < ActiveRecord::Base
  has_many :statements
end
