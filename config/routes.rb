Rails.application.routes.draw do
  devise_for :users

  concern :votesable do
    member do
      patch 'vote_plus'
      patch 'vote_minus'
      patch 'vote_cancel'
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: [:destroy]
    member do
      post 'comment_create'
      get 'comment_index'
    end
  end

  resources :questions, concerns: [:votesable, :commentable] do
    resources :answers, concerns: [:votesable, :commentable], shallow: true do
      patch 'assign_best', on: :member
    end
  end
  root 'questions#index'
  resources :attachments, only: :destroy
end
