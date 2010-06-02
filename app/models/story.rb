require 'authorization/authz'

class Story < ActiveRecord::Base
  include Authz

  belongs_to :sprint
  belongs_to :project
  belongs_to :user
  has_many :comments
  set_table_name 'backlog'
  validates_presence_of :project_id, :name, :importance

  before_validation {|story|
    if story.finished
      old_story= Story.find(story.id)
      story.end_date= Time.new unless old_story.finished
    end
  }

  before_validation_on_create {|story|
    story.authorize! :CREATE_STORY, story.project
  }
  before_validation_on_update {|story|
    story.authorize! :UPDATE_STORY, story.project
  }
  before_destroy {|story|
    story.authorize! :UPDATE_STORY, story.project
  }

  # ////////////////////////////////////////////
  # BUSINESS LOGIC
  # ////////////////////////////////////////////

  def pending?()
    !finished && !user_id
  end
  def workingonit?()
    !finished && user_id
  end
  def finished?()
    finished
  end
  def to_pending()
    self[:finished] = false
    self[:end_date] = nil
    self[:user_id] = nil
  end
  #
  # @param assignee_id The user id of the assignee.
  #
  def to_workingonit(assignee_id=self[:user_id])
    self[:finished] = false
    self[:user_id] = assignee_id
    self[:start_date] = Time.new
  end
  def to_finished(assignee_id=self[:user_id])
    self[:finished]= true
    self[:user_id] = assignee_id
    self[:end_date]= Time.new
  end
end
