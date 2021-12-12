Rails.application.routes.draw do
  resources :pets

  # devise_for :users
  devise_for :users, controllers: {sessions: 'users/sessions'}
  # # devise_for :users, path: "users",
  # #                    controllers: { sessions: "users/sessions", registrations: "users/registrations" },
  # #                    path_names: { sign_in: 'login', password: 'forgot', confirmation: 'confirm', unlock: 'unblock', sign_up: 'register', sign_out: 'signout'}
  devise_scope :user do
    get 'users/auth', as: :auth_user_session, to: 'users/sessions#auth_token'
    get 'login/new',  as: :new_login,    to: 'users/sessions#new_token'
    post 'login',                        to: 'users/sessions#create_token'
    get 'logout',                        to: 'users/sessions#logout_token'
  end
  #     new_user_session  GET     /users/sign_in(.:format)                                                                          devise/sessions#new
  #         user_session  POST    /users/sign_in(.:format)                                                                          devise/sessions#create
  # destroy_user_session  DELETE  /users/sign_out(.:format)                                                                         devise/sessions#destroy


  get 'home',     to: 'pets#index'
  get 'landing',  to: 'landing#index'
  root            to: "landing#index"
end
