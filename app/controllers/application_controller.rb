class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  include SessionsHelper

  def page_not_found
    e = Error.new(:status => 404, :message => "Wrong URL or HTTP method")
    render :json => e.to_json, :status => 404
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user) || current_user.admin?
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
