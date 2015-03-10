Rails.application.routes.draw do
  # There is only one controller with only three methods,
  # so we limit the access to only the active ones
  resources :anagrams, only: [:index, :create, :show]
  root to: 'anagrams#index'
end
