class Commodity < ActiveRecord::Base
  validates :code, uniqueness: true
end
