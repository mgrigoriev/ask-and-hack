Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch 'vote_up'
      patch 'vote_down'
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true do
      patch 'make_best', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'
end
