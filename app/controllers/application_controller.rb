class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_categories
  before_action :set_users
  
  protected
  
  def authenticate_editor!
    redirect_to root_path, alert: "Usted no tiene permisos para esta Accion" unless user_signed_in? && current_user.is_editor?
  end
  def authenticate_admin!
    redirect_to root_path, alert: "Usted no tiene permisos para esta Accion" unless user_signed_in? && current_user.is_admin?
  end
  
  private
  
  def set_categories
    @categories = Category.all
  end
  
  def set_users
    if user_signed_in?
         @users = current_user
      else
         @users = nil
    end
  end
  
end
