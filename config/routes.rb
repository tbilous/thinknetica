Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  use_doorkeeper
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    confirmations:      'users/confirmations',
    registrations:      'users/registrations'
  }

  as :user do
    get 'signup_email', to: 'users/registrations#edit_email', as: :edit_signup_email
    post 'signup_email', to: 'users/registrations#update_email', as: :update_signup_email
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  concern :votesable do
    member do
      patch 'vote_plus'
      patch 'vote_minus'
      patch 'vote_cancel'
    end
  end

  resources :comments, only: [:destroy]

  resources :questions, concerns: [:votesable] do
    resources :answers, concerns: [:votesable], shallow: true do
      patch 'assign_best', on: :member
      resources :comments, only: [:create], defaults: { context: 'answer' }
    end
    resources :comments, only: [:create], defaults: { context: 'question' }
  end

  root 'questions#index'
  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
