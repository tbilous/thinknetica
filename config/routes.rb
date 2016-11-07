Rails.application.routes.draw do
  devise_for :users

  concern :votesable do
    member do
      patch 'vote_plus'
      patch 'vote_minus'
      patch 'vote_cancel'
    end
  end

  resources :questions, concerns: [:votesable] do
    resources :answers, concerns: [:votesable], shallow: true do
      patch 'assign_best', on: :member
    end
  end
  root 'questions#index'
  resources :attachments, only: :destroy
end
