Rails.application.routes.draw do
  devise_for :users

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
