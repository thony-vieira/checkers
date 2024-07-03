# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :games, only: [:create, :show] do
        member do
          post :join
          get :state
          get :status
          post :move
          get :possible_moves
        end
      end
    end
  end
end
