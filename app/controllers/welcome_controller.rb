class WelcomeController < ApplicationController
  before_action :authenticate_admin!, only: [:dashboard,:list_article,:list_category]
  def index
    
  end
  
  def list_article
    @articles = Article.all
  end
  
  def list_category
    @categories = Category.all
  end
  
end
