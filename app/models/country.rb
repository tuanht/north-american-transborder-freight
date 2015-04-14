class Country < ActiveRecord::Base
  validates :code, uniqueness: true
  validates_length_of :code, maximum: 4

  has_many :state
end
