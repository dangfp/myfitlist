class PlansController < ApplicationController
  before_action :require_sign_in
  before_action :set_plan, only: [:show, :update]

  def new
    if current_user.has_today_plan?
      flash[:danger] = "您已经创建了今日的健身规划。"
      redirect_to plan_path(current_user.today_plan)
    else
      @plan = Plan.new
    end
  end

  def create
    current_user = User.find(session[:user_id]) if session && session[:user_id]
    @plan = Plan.new(plan_params)
    @plan.user_id = current_user.id

    if @plan.save
      redirect_to plan_path(@plan)
    else
      render :new
    end
  end

  def show
  end

  def update
    if @plan.update(plan_params)
      redirect_to plan_path(@plan)
    else
      render :show
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:weight)
  end
end