#
# Management of sprint backlog. This is, the backlog that belongs to a single
# sprint.
#
class SprintBacklogController < ApplicationController
  before_filter :require_user

  def index
    @sprint= Sprint.find(params[:sprint_id])
    if (:sprint_id)
      @backlog = Story.find_all_by_sprint_id(params[:sprint_id], :order => "importance DESC")
      render :template => 'sprint_backlog/index'
    else
      throw "a sprint backlog should define the spring id!"
      # @backlog = Story.find(:order => "importance DESC")
    end
  end

#  def show
#    @story = Story.find(params[:id])
#  end

  # /////////////////////////////////////////
  # AJAX methods
  # /////////////////////////////////////////

  # AJAX
  #
  # Assotiates a story to the sprint backlog.
  #
  def create
    
    @story = Story.find(params[:id])
    sprint= Sprint.find params[:sprint_id]
    sprint.backlog << @story

    respond_to do |format|
      format.html { redirect_to sprint_backlog_path(sprint)}
      format.xml  { render :nothing=>true }
      format.json { render :nothing=>true }
    end
  end

  # AJAX
  #
  # Removes a story from a sprint backlog. But it stays in the project backlog.
  #
  def destroy
    story= Story.find(params[:id])
    sprint= Sprint.find(params[:sprint_id])
    sprint.backlog.delete story

    respond_to do |format|
      format.html { redirect_to sprint_backlog_path(sprint)}
      format.xml  { render :nothing=>true }
      format.json { render :nothing=>true }
    end
  end

  #
  # AJAX
  #
  def show
    @story= Story.find(params[:id])

    respond_to do |format|
      format.html { render :partial => 'show', :object => @story}
      format.xml  { render :xml => @story.to_xml }
    end
  end

  #
  # AJAX
  #
  def change_state
    @story= Story.find(params[:id])

    new_state= params[:state]
    logger.info "Changing story #{@story.id} state..."

    if new_state == 'pending'
      @story.to_pending
    elsif new_state == 'workingonit'
      @story.to_workingonit current_user.id
    else #finished
      if @story.user
        @story.to_finished
      else
        @story.to_finished current_user.id
      end
    end
    @story.save!
    logger.info "...story #{@story.id} state canged to #{new_state}..."

    render :partial => 'story_row', :locals => {:story => @story}
#    respond_to do |format|
#      format.html { render :partial => 'show', :object => @story}
#      format.xml  { render :xml => @story.to_xml }
#    end
  end
end
