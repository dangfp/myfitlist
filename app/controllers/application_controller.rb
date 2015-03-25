class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end

  def require_sign_in
    if !current_user
      flash[:danger] = "请先登录"
      redirect_to sign_in_path
    end
  end

  def show_user_today_planning(user)
    if user.has_today_planning?
      redirect_to planning_path(user.today_planning)
    else
      redirect_to new_planning_path
    end
  end
end
