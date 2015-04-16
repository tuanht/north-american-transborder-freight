class Trade < ActiveRecord::Base
  belongs_to :country
  belongs_to :usa_state
  belongs_to :port
  belongs_to :mode
  belongs_to :commodity

  enum trade_type: [:unknown, :export, :import]
  enum df: [:undefined, :domestically, :foreign]
  enum table_type: [:with_state_and_port, :with_state_and_commodity, :with_port_and_commodity]

  scope :with_state_and_port, -> {where table_type: 0}
  scope :with_state_and_commodity, -> {where table_type: 1}

  def self.summary
    sums = with_state_and_port.group([:date, :trade_type]).select('date, trade_type, table_type, country_id, SUM(value) as sum_value, SUM(shipwt) as sum_shipwt, SUM(freight_charges) as sum_freight_charges')
    sum_export = sums.where trade_type: Trade.trade_types[:export]
    sum_import = sums.where trade_type: Trade.trade_types[:import]
    {
        export: sum_export.map {|s| map_summary s},
        import: sum_import.map {|s| map_summary s}
    }
  end

  def self.summary_sum_value
    sums = with_state_and_port.group(:trade_type).sum(:value)
    {
        export: sums[trade_types[:export]].to_d,
        import: sums[trade_types[:import]].to_d,
    }
  end

  private
  def self.map_summary(o)
    {
        date: o.date,
        value: o.sum_value.to_i,
        shipwt: o.sum_shipwt,
        freight_charges: o.sum_freight_charges
    }
  end
end
