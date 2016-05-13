Rails.application.routes.draw do
  root 'home#index'
  post '/instagram/tag/buscar', to: 'home#instagram_tag'
end
