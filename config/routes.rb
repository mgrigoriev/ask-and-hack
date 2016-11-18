Rails.application.routes.draw do
  devise_for :users,
              controllers: {
                omniauth_callbacks: 'omniauth_callbacks',
                registrations: 'users/registrations',
                confirmations: 'users/confirmations'
              }

  as :user do
    get 'signup_email', to: 'users/registrations#edit_email', as: :edit_signup_email
    post 'signup_email', to: 'users/registrations#update_email', as: :update_signup_email
  end

  concern :votable do
    member do
      patch 'vote_up'
      patch 'vote_down'
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: :create
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      patch 'make_best', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
