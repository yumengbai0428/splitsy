Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'sessions#welcome'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :transactions, :users, :repayments
  get 'login', to: 'users#login'
  post 'login', to: 'users#validate'
  get 'show', to: 'users#show'
  get 'welcome', to: 'sessions#welcome'
  post 'welcome', to: 'sessions#welcome'
  post 'create', to: 'sessions#create'
  get 'logout', to: 'transactions#logout'
  get 'all-transactions', to: 'transactions#list'
  post 'all-transactions', to: 'transactions#list'
  get 'all-repayments', to: 'repayments#list'
  post 'all-repayments', to: 'repayments#list'
  get 'visualize-transactions', to: 'transactions#visualize'
end
