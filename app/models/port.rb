class Port < ActiveRecord::Base
  validates :code, uniqueness: true
  validates_length_of :code, maximum: 4

  scope :by_district, -> {where type: :district}
  scope :by_port, -> {where type: :port}
  scope :by_code, ->(code) {where code: code}

  enum port_type: [:district, :port]
end
