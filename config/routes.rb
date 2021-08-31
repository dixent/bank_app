Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated do
      resources :bank_accounts, only: %i[show]
      resources :checks, only: %i[create]

      root 'bank_accounts#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
