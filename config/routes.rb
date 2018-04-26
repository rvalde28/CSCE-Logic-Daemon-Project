Rails.application.routes.draw do
  root to: 'logic#home'
  
  get 'logic/home'

  get 'logic/primer'

  get 'logic/quizmaster'

  get 'logic/daemon'

  get 'logic/checkers'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
