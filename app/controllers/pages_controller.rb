class PagesController < ApplicationController
  def front
    if signed_in?
      show_user_today_plan(current_user)
    else
      render :front
    end
  end
end