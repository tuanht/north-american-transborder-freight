Rails.application.routes.draw do
  root 'home#index'
  get 'export_summary', to: 'home#export_summary'

  namespace :api, :defaults => {:format => :json} do
    get 'summary', to: 'home#summary'
  end
end
