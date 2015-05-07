class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && User.authenticate(false, params[:session][:email], params[:session][:password])

      # Log in the user if active

      if user.activated?
        log_in user
        params[:session][:remember] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Email not verified!"
        message += "Check your email for the verification link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end
end
