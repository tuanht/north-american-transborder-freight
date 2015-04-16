class Api::HomeController < Api::ApplicationController
  def summary
    render :json => Trade.summary
  end
end
