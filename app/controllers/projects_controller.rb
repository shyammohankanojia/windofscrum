class ProjectsController < ApplicationController
  before_filter :require_user

  def index
    @projects = Project.find(:all)
    return @projects
  end

  def show
    @project = Project.find(params[:id])
    resolve_pigs
  end

  def new
    @project = Project.new
    resolve_pigs
  end

  def create
    project_props= params[:project]

    pigs= remove_pigs_from_props project_props
    @project = Project.create(project_props, pigs)
    if @project.valid?
      flash[:notice] = 'Project was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end

  end

  def edit
    @project = Project.find(params[:id])
    resolve_pigs
  end

  def update
    @project = Project.find(params[:id])
    project_props= params[:project]
    pigs= remove_pigs_from_props(project_props)

    @project.update_props(project_props, pigs)
    if @project.save()
      flash[:notice] = 'Project was successfully updated.'
      redirect_to :action => 'show', :id => @project
    else
      render :action => 'edit'
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  #
  #  PRIVATE METHODS
  #
  private
  #
  #Resolves the selected pigs on the view selects.
  # Sets the defaults for the pigs if none is still selected.
  #
  def resolve_pigs
    if !@project.pigs.empty?
      product_owner= @project.product_owner
      @actual_product_owner=  product_owner ? product_owner.user_id : current_user_session.user.id

      scrum_master= @project.scrum_master
      @actual_scrum_master= scrum_master ? scrum_master.user_id : current_user_session.user.id

      @actual_team= @project.team.collect {|pig| pig.user_id}
    end
  end
  def remove_pigs_from_props(project_props)
    {:product_owner => project_props.delete('product_owner'),
      :scrum_master => project_props.delete('scrum_master'),
      :team=>project_props.delete('team')}
  end
end
