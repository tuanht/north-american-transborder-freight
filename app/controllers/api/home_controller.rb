class Api::HomeController < Api::ApplicationController
  def summary
    render :json => Trade.summary
  end

  def summary_sum_value
    render :json => Trade.summary_sum_value
  end
end
