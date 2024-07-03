Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :games, only: [:create] do
        member do
          post 'join'
          get 'state'
          get 'possible_moves'
          get 'status'
          post 'move'
        end
      end
    end
  end
end
