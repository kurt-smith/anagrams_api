# frozen_string_literal: true

Rails.application.routes.draw do
  resources :words, only: %i[create destroy], param: :word_name do
    collection do
      delete '', to: 'words#destroy_all'
    end
  end

  resources :anagrams, only: %i[show], param: :word_name
end
