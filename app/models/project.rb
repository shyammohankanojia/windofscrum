require 'authorization/authz'

class Project < ActiveRecord::Base
  include Authz

  has_many :sprints
  has_many :backlog, :class_name => "Story", :order => "importance DESC"
  has_many :pigs, :class_name => "Member", :dependent => :destroy

  validates_presence_of :name

  before_validation_on_create {|project|
    project.authorize!(:CREATE_PROJECT)
  }
  before_validation_on_update {|project|
    project.authorize! :UPDATE_PROJECT, project
  }

  # //////////////////////////////////////////
  # PROJECT
  # //////////////////////////////////////////
  def destroy
    authorize! :UPDATE_PROJECT, self
    super()
  end

  #
  # Creates and persists a new project with the given 'props'.
  #
  # If the received 'props' result in an invalid project, this new project
  # will fail to persist. It can be checked by asking the returned project
  # '.valid?'.
  #
  # Note: Some of the pigs may also fail to persist. 'valid?' should be asked on each one.
  #
  # @return the brand new project
  #
  def self.create(props, pigs)

    project = Project.new(props)
    project.save
    project.set_pigs pigs
    project
  end

  def update_props(props, pigs)

    update_attributes(props)
    set_pigs(pigs)
  end

  # //////////////////////////////////////////
  # SPRINTS
  # //////////////////////////////////////////

  #
  # Builds a new sprint withou pesisting it.
  # @return the builded sprint.
  #
  def build_sprint(props= {})
    authorize!(:CREATE_SPRINT, self)

    sprints.build props
  end

  # //////////////////////////////////////////
  # BACKLOG
  # //////////////////////////////////////////

  #
  # Builds a new story withou pesisting it.
  # @return the builded story.
  #
  def build_story(props= {})
    authorize!(:CREATE_STORY, self)

    backlog.build props
  end

  # //////////////////////////////////////////
  # PIGS
  # //////////////////////////////////////////
  def product_owner
    pigs.find(:first, :conditions => ['role=?', Member::PRODUCT_OWNER])
  end
  def scrum_master
    pigs.find(:first, :conditions => ['role=?', Member::SCRUM_MASTER])
  end
  def team
    pigs.find(:all, :conditions => ['role=?', Member::TEAM])
  end

  # Assotiates the new members to this project.
  # Note: This operation will remove former members.
  def set_pigs(members)
    pigs.clear
    product_owner= members[:product_owner]
    pigs.create(:user_id => product_owner, :role=>Member::PRODUCT_OWNER) if product_owner
    scrum_master= members[:scrum_master]
    pigs.create(:user_id => scrum_master, :role=>Member::SCRUM_MASTER) if scrum_master
    team= members[:team]
    team.each { |p| pigs.create(:user_id => p, :role=>Member::TEAM) } if team
  end
end
