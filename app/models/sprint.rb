require 'authorization/authz'

class Sprint < ActiveRecord::Base
  include Authz

  belongs_to :project
  has_many :backlog, :class_name => "Story", :order => "importance DESC"

  before_validation_on_create {|sprint|
    sprint.authorize! :CREATE_SPRINT, sprint.project
  }
  before_validation_on_update {|sprint|
    sprint.authorize! :UPDATE_SPRINT, sprint.project
  }
  before_destroy {|sprint|
    sprint.authorize! :UPDATE_SPRINT, sprint.project
  }


  # //////////////////////////////////////////
  # BUSINESS LOGIC
  # //////////////////////////////////////////

  # updates the estimated focus factor with the one from
  # the last sprint, if any
  def update_estimated_focus_factor
    last_sprint= get_last_sprint()
    if (!last_sprint.nil? && last_sprint.finished)
      self[:estimated_focus_factor] = (last_sprint.focus_factor*100.0).round
    else
      self[:estimated_focus_factor] = 0
    end
  end

  def get_last_sprint
    sprints= project.sprints
    unless (sprints.nil?)
      unless (self[:id].nil?)
        sprints.last
      else
        sprints[sprints.length - 2]
      end
    end
  end

  # Can only be computed once the sprint has finished
  def actual_velocity
    velocity = 0
    if (backlog != nil)
      backlog.each { |story|
        if (story.finished && !story.initial_estimate.nil?)
          velocity+= story.initial_estimate
        end
      }
    end
    velocity
  end

  # Can only be computed once the sprint has finished
  def focus_factor
    if ((not read_attribute(:finished)) or read_attribute(:available_man_days) <= 0)
      return nil
    end

    actual_velocity.to_f / read_attribute(:available_man_days).to_f
  end

  def can_estimate_velocity
    (!self[:available_man_days].nil? and !self[:estimated_focus_factor].nil? and
        self[:available_man_days] > 0 and self[:estimated_focus_factor] > 0)
  end

  # @throws :more_information_is_needed if <code>can_estimate_velocity</code>
  # returns false
  def estimate_velocity
    if (not can_estimate_velocity)
      throw :more_information_is_needed
    end
    self[:available_man_days] * self[:estimated_focus_factor]
  end

  # The estimated focus factor in tant per one.
#  def ff
#    factor= self[:estimated_focus_factor]
#    factor/100.0 if factor
#  end

  def remaining_work_on_date(date)
    stories= backlog.find(:all, :conditions => ['end_date > ? or end_date is null',date])
    work= 0
    stories.each {|story|
      work+= story.initial_estimate if story.initial_estimate
    }
    work
  end
end
