class SprintsController < ApplicationController
  before_filter :require_user

  def index
    if (params[:project_id])
      by_project
    else
      @sprints = Sprint.find(:all)
    end
  end

  def by_project
    @sprints = Sprint.find_all_by_project_id params[:project_id]
  end

  def show
    @sprint = Sprint.find(params[:id])
  end

  def new
    @sprint = Sprint.new
    @sprint.project_id= params[:project_id]
  end

  def create
    @sprint = Sprint.new(params[:sprint])
    if @sprint.save
      flash[:notice] = 'Sprint was successfully created.'
      redirect_to project_sprints_url(@sprint.project)
      #redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @sprint = Sprint.find(params[:id])
  end

  def update
    @sprint = Sprint.find(params[:id])
    if @sprint.update_attributes(params[:sprint])
      flash[:notice] = 'Sprint was successfully updated.'
      redirect_to :action => 'show', :id => @sprint
    else
      render :action => 'edit'
    end
  end

  def destroy
    sprint= Sprint.find(params[:id])
    p= sprint.project
    sprint.destroy
    redirect_to :action => 'index', :project_id => p.id
  end

  def update_estimated_focus_factor
    @sprint= Sprint.find(params[:id])
    @sprint.update_estimated_focus_factor
    @sprint.save!
    redirect_to :action => 'show', :id => @sprint
  end
end
