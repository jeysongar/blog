class ArticlesController < ApplicationController
  
  before_action :authenticate_user!, except: [:show,:index]
  before_action :set_article, except: [:index,:new,:create]
  before_action :authenticate_editor!, only: [:new,:create,:update]
  before_action :authenticate_admin!, only: [:destroy,:publish,:unpublish]
  
  #GET /articles
  def index
    #paginate depende de la gema will_paginate
    @articles = Article.paginate(page: params[:page],per_page:3).publicados.ultimos
  end
  
  #GET /articles/:id
  def show
    # esta vacio por que before_action :set_article nos ayuda a no repetir nuestro codigo inecesariamente 
    @article.update_visits_count
    @comment = Comment.new
  end
  
  #GET /articles/new
  def new
    @article = Article.new
    @categories = Category.all
  end
  
  #POST /articles
  def create
    #article_params es una funcion que utilizamos para definir seguridad de nuestra base de datos contra mysql inyection
    @article = current_user.articles.new(article_params)
    @article.categories = params[:categories]
    if @article.save 
      redirect_to @article
    else
      render :new
    end
  end
  
  #GET /articles/:id/edit
  def edit
    # esta vacio por que before_action :set_article nos ayuda ano repetir nuestro codigo inecesariamente 
  end
  #PUT /articles/:id
  def update
    # esta vacio por que before_action :set_article nos ayuda a no repetir nuestro codigo inecesariamente 
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
    #@article.update_attributes({})
  end
  
  #DELETE /articles/:id
  def destroy
    # esta vacio por que before_action :set_article nos ayuda a no repetir nuestro codigo inecesariamente
    @HasCategories = HasCategory.where("article_id = #{params[:id]}")
    if @HasCategories.destroy_all
       @article.destroy
    end
    redirect_to "/dashboard"
  end
  
  def publish
    @article.publish!
    redirect_to "/dashboard"
  end
  
  def unpublish
    @article.unpublish!
    redirect_to "/dashboard"
  end
  
  private
  # fracmento de codigo que se repite en varias vistas y asi lo empleamos con before_action
  def set_article
    @article = Article.find(params[:id])
  end
  
  def validation_user
    redirect_to new_user_session_path, notice: "Necesitas iniciar sesion"
  end
  
  def article_params
    params.require(:article).permit(:title,:body,:cover,:categories)
  end
end
