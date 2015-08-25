Rails.application.routes.draw do
  
  resources :categories
  resources :articles do 
    resources :comments, only: [:create, :destroy, :update,:show]
  end
  devise_for :users
  root 'articles#index'
  
  get "/list_article", to: "welcome#list_article"
  get "/list_category", to: "welcome#list_category"
  
  put "/articles/:id/destroy", to: "articles#destroy"
  put "/articles/:id/publish", to: "articles#publish"
  put "/articles/:id/unpublish", to: "articles#unpublish"
  
end
