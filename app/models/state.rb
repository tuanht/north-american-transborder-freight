class State < ActiveRecord::Base
  belongs_to :country

  validates :code, uniqueness: { scope: :country_id}, length: {maximum: 2}
end
