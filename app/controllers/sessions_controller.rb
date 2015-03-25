class SessionsController < ApplicationController
  def new
    if signed_in?
      show_user_today_plan(current_user)
    else
      render :new
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      show_user_today_plan(user)
    else
      flash[:danger] = "Email或者密码不匹配，请重新输入"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end