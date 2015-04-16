class Country < ActiveRecord::Base
  validates :code, uniqueness: true, length: {maximum: 4}

  has_many :state
end
