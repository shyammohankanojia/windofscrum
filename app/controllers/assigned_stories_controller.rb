class AssignedStoriesController < ApplicationController
  before_filter :require_user

  # GET
  # Returns a map with key:sprint and value:story
  def index
    @project= Project.find params[:project_id]
    sprints= @project.sprints
    @assigned_stories= Hash.new
    sprints.each { |sprint| @assigned_stories[sprint]= Array.new }
    @assigned_stories[nil]= Array.new
    @project.backlog.each { |story|
      @assigned_stories[story.sprint].<<(story)
    }
    @assigned_stories
  end

  def update
  end

  def delete
  end
end
