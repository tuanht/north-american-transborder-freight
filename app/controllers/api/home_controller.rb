class Api::HomeController < Api::ApplicationController
  include ActionView::Helpers::NumberHelper

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

  def by_usa_state
    import = Trade.by_usa_state_import
    export = Trade.by_usa_state_export

    render :json => {
               import: import.map do |i|
                 map_usa_state i
               end,
               export: export.map do |e|
                 map_usa_state e
               end
           }
  end

  private

  def map_summary(o)
    {
        date: o.date.strftime("%B %Y"),
    }.merge get_sum_values(o)
  end

  def map_usa_state(o)
    {
        usa_state: UsaState.find(o.usa_state_id).name
    }.merge get_sum_values(o)
  end

  def get_sum_values(o)
    {
        value: o.sum_value.to_money(:USD).format,
        shipwt: "#{number_to_human o.sum_shipwt} Kilograms",
        freight_charges: o.sum_freight_charges.to_money(:USD).format
    }
  end
end
