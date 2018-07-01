# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :words, only: %i[create destroy], param: :word_name do
    collection do
      delete '', to: 'words#destroy_all', as: :all
    end
  end

  resources :anagrams, only: %i[show], param: :word_name

  # catch all invalid routes
  match '*unmatched_route', to: 'application#raise_not_found!', via: :all
end
