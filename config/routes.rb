Rails.application.routes.draw do
  devise_for :users

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
end
