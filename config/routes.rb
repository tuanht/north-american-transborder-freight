Rails.application.routes.draw do
  root 'home#index'
  get 'export_summary', to: 'home#export_summary'
  get 'search', to: 'search#index'

  namespace :api, :defaults => {:format => :json} do
    get 'summary', to: 'home#summary'
    get 'summary/usa_state', to: 'home#by_usa_state'
    get 'trades', to: 'search#trades'
    get 'countries', to: 'search#countries'
    get 'ports', to: 'search#ports'
    get 'states', to: 'search#states'
    get 'commodities', to: 'search#commodities'
  end
end
