class Port < ActiveRecord::Base
  validates :code, uniqueness: true, length: {maximum: 4}

  scope :by_district, -> {where type: :district}
  scope :by_port, -> {where type: :port}

  enum port_type: [:district, :port]
end
