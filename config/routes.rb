Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :urls, only: [ :create ]

  get '/stats/*path' => 'short_url_visits#get_stats'

  get '*path' => 'urls#show'

end
