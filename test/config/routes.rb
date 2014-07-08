Rails.application.routes.draw do
  resources :users 

   match '/signup',  to: 'users#new', via: 'get'
  # match '/signin',   to: 'sessions#new'
  # match '/signout',  to: 'sessions#destroy', via: :delete

  # match '/help',    to: 'static_pages#help'
  # match '/about',   to: 'static_pages#about'
  # match '/contact', to: 'static_pages#contact

  root to: 'front_page#home'

  # match '/signup',   to: 'users#new'
  # match '/signin',   to: 'sessions#new'
  # match '/signout',  to: 'sessions#destroy', via: :delete

  # match '/help',    to: 'static_pages#help'
  # match '/about',   to: 'static_pages#about'
  # match '/contact', to: 'static_pages#contact'

end
