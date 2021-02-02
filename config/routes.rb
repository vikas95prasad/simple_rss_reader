# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'feeds#index'

  resources :feeds
  resources :posts, only: %i[index]
  get 'home/help'

  get '*path', to: redirect('/')
end
