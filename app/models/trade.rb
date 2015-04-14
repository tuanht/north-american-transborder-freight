class Trade < ActiveRecord::Base
  belongs_to :country
  belongs_to :usa_state
  belongs_to :port
  belongs_to :mode
  belongs_to :commodity

  enum trade_type: [:unknown, :export, :import]
  enum df: [:undefined, :domestically, :foreign]
  enum table_type: [:with_state_and_port, :with_state_and_commodity, :with_port_and_commodity]

  scope :by_year_and_month, ->(year, month) {where date: Date.new(year, month, 1)}
  scope :with_state_and_port, -> {where table_type: 0}
  scope :with_state_and_commodity, -> {where table_type: 1}

  scope :summary, -> {with_state_and_port.group([:date, :trade_type]).select('date, trade_type, country_id, SUM(value) as sum_value, SUM(shipwt) as sum_shipwt, SUM(freight_charges) as sum_freight_charges')}
  scope :summary_export, -> {summary.where(trade_type: 1)}
  scope :summary_import, -> {summary.where(trade_type: 2)}

  scope :by_usa_state, -> {with_state_and_commodity.group([:usa_state_id, :trade_type]).select('trade_type, usa_state_id, SUM(value) as sum_value, SUM(shipwt) as sum_shipwt, SUM(freight_charges) as sum_freight_charges')}
  scope :by_usa_state_export, -> {by_usa_state.where(trade_type: 1)}
  scope :by_usa_state_import, -> {by_usa_state.where(trade_type: 2)}
end
