Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    patch 'vote_up', on: :member
    patch 'vote_down', on: :member   

    resources :answers, shallow: true do
      patch 'make_best', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'
end
