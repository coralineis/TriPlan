class Public::PlansController < ApplicationController
  before_action :search

  def new
    @plan = Plan.new
  end

  def confirm
    @plan = Plan.new(plan_params)
    @plan.user_id = current_user.id
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user_id = current_user.id
    @plan.save
    if params[:back] || !@plan.save
      render :new and return
    end
    redirect_to plan_path(@plan.id)
  end

  def search
    @q = Plan.ransack(params[:q])
  end

  def index
    @plans = @q.result(distinct: true).order(id: "DESC")
    @tags = Plan.tag_counts_on(:tags)
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    @plan.update(plan_params)
    redirect_to plan_path(@plan.id)
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to my_page_path(current_user)
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :place_name, :time, :stay_night, :introduction, :tag_list, :image_cache, { images: [] })
  end
end
