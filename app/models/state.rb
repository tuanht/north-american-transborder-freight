class State < ActiveRecord::Base
  belongs_to :country

  validates :code, uniqueness: { scope: :country_id}

  validates_length_of :code, maximum: 2
end
