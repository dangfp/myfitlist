class PlanningsController < ApplicationController
  before_action :require_sign_in
  before_action :set_planning, only: [:show, :update]

  def new
    if current_user.has_today_planning?
      flash[:danger] = "您已经创建了今日的健身规划。"
      redirect_to planning_path(current_user.today_planning)
    else
      @planning = Planning.new
    end
  end

  def create
    current_user = User.find(session[:user_id]) if session && session[:user_id]
    @planning = Planning.new(planning_params)
    @planning.user_id = current_user.id

    if @planning.save
      redirect_to planning_path(@planning)
    else
      render :new
    end
  end

  def show
  end

  def update
    if @planning.update(planning_params)
      redirect_to planning_path(@planning)
    else
      render :show
    end
  end

  private

  def set_planning
    @planning = Planning.find(params[:id])
  end

  def planning_params
    params.require(:planning).permit(:weight)
  end
end