class Api::HomeController < Api::ApplicationController
  def summary
    import = Trade.summary_import
    export = Trade.summary_export
    render :json => {
               import: import.map do |i|
                 map_summary i
               end,
               export: export.map do |e|
                 map_summary e
               end
           }
  end

  private

  def map_summary(o)
    {
        date: o.date,
    }.merge get_sum_values(o)
  end

  def get_sum_values(o)
    {
        value: o.sum_value,
        shipwt: "#{number_to_human o.sum_shipwt} Kilograms",
        freight_charges: o.sum_freight_charges
    }
  end
end
