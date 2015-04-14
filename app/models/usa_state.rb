class UsaState < ActiveRecord::Base
  validates :code, uniqueness: true

  validates_length_of :code, maximum: 2
end
