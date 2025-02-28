# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  namespace :admin do
    resources :users

    root to: "users#index"
  end
  extend DemoPackRoutes
  extend OauthRoutes
  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index create]
      resources :schools, only: %i[index] do
        collection do
          get "index_fetch_only"
          get "index_fetch_and_store_on_db"
          get "index_fetch_and_store_on_cache_and_db"
        end
      end
    end
  end
  devise_scope :user do
    post "/api/v1/tokens", to: "devise/api/tokens#sign_in", as: "api_v1_sign_in_user_token"
  end
end
