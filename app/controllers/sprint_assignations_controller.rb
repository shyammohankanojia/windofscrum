#
# Management of sprint backlog assignations.
#
class SprintAssignationsController < ApplicationController
  before_filter :require_user

  def index
    @sprint= Sprint.find(params[:sprint_id])
    if (:sprint_id)
      @backlog = Story.find_all_by_sprint_id(params[:sprint_id], :order => "importance DESC")
      @next = Story.find(:first, :conditions => ["project_id=? and sprint_id is null", @sprint.project_id], :order => "importance DESC")
      render :template => 'sprint_assignations/index'
    else
      throw "a sprint backlog should define the spring id!"
    end
  end

  # /////////////////////////////////////////
  # AJAX methods
  # /////////////////////////////////////////

  # 
  # Assotiates a story to the sprint backlog.
  #
  def create
    
    @story = Story.find(params[:id])
    sprint= Sprint.find params[:sprint_id]
    sprint.backlog << @story

    respond_to do |format|
      format.html { redirect_to sprint_assignations_path(sprint)}
      format.xml  { render :nothing=>true }
      format.json { render :nothing=>true }
    end
  end
  # 
  # Removes a story from a sprint backlog. But it stays in the project backlog.
  #
  def destroy
    story= Story.find(params[:id])
    sprint= Sprint.find(params[:sprint_id])
    sprint.backlog.delete story

    respond_to do |format|
      format.html { redirect_to sprint_assignations_path(sprint)}
      format.xml  { render :nothing=>true }
      format.json { render :nothing=>true }
    end
  end
end
