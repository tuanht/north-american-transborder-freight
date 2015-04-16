class Api::SearchController < Api::ApplicationController
  def trades
    criteria = {}
    search_params.each do |k, v|
      criteria[k.to_sym] = v if v
    end
    page_index = params[:page_index]
    page_size = params[:page_size]
    trades = Trade.where(criteria).page(page_index).per(page_size)
    render :json => {
               trades: trades,
               total_items: trades.total_count
           }
  end

  def countries
    respond_with Country.all
  end

  def ports
    respond_with Port.all
  end

  def states
    respond_with State.all
  end

  def commodities
    respond_with Commodity.all
  end

  private

  def search_params
    params.permit(:country_id, :state_id, :commodity_id, :port_id, :mode_id)
  end


end
