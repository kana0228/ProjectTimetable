Rails.application.routes.draw do
  

  
  get 'signup/view', to: 'signup#view'
  post 'signup/create', to: 'signup#create'
  root 'login_page#login'
  
  post 'login/create', to: 'login_page#create'
  
  post 'result/show'
  get 'main_page/create'
  get 'main_page/show'
  get 'main_page/reshow'
  post 'main_page/create'
  get 'main_page/update', to: 'main_page#update'
  get 'main_page/edit'
  get 'login_page/login'
  
  get '/auth/:provider/callback', to: 'twitter_callback#create'
  delete '/logout', to: 'twitter_callback#destory'
  #カレンダー表示用
  get 'events', to: 'main_page#events'
  
  resources :events
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
