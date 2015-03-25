class ItemsController < ApplicationController
  before_action :require_sign_in
  before_action :set_plan

  def new
    @item = Item.new
  end

  def create
    @item = @plan.items.build(item_params)

    if @item.save
      redirect_to plan_path(@plan)
    else
      render :new
    end
  end

  def update
    item = Item.find(params[:id])

    if item.update(item_params)
      flash[:success] = "保存成功"
      redirect_to plan_path(@plan)
    else
      flash[:danger] = "健身项目信息有误，请更正"
      render "plans/show"
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.delete if !item.finished and item.plan_id == @plan.id
    redirect_to plan_path(@plan)
  end

  private

  def item_params
    params.require(:item).permit(:finished, :name, :duration, :result, :unit)
  end

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end