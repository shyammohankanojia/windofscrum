# This class defines authorization policies and implements the
# authorization mechanism.
#

module Authz

  #
  # To be used as a service simply instantiate this class.
  #
  class Service
    include Authz
  end

  # ACTIONS
  #
  # This are the actions to be authorized.
  #
  # :CREATE_PROJECT
  # :UPDATE_PROJECT
  # :CREATE_SPRINT
  # :UPDATE_SPRINT
  # :CREATE_STORY
  # :UPDATE_STORY
  # :ASSIGN_STORY_TO_SPRINT

  # AUTHORIZATIONS
  #
  # Here we authorize actions to roles.
    # Map of roles to permissions.
  AUTHORIZATIONS =  {
    # AS A USER
    :ADMIN => ['*'],
    :USER => [:CREATE_PROJECT],
    # AS A PROJECT MEMBER
    :PRODUCT_OWNER => [:CREATE_PROJECT,
      :UPDATE_PROJECT,
      :CREATE_SPRINT,
      :UPDATE_SPRINT,
      :CREATE_STORY,
      :UPDATE_STORY,
      :ASSIGN_STORY_TO_SPRINT],
    :SCRUM_MASTER => [:CREATE_PROJECT,
      :UPDATE_PROJECT,
      :CREATE_SPRINT,
      :UPDATE_SPRINT,
      :CREATE_STORY,
      :UPDATE_STORY,
      :ASSIGN_STORY_TO_SPRINT],
    :TEAM => [:CREATE_PROJECT,
      :CREATE_STORY,
      :UPDATE_STORY,
      :ASSIGN_STORY_TO_SPRINT]
  }

  class AuthzException < StandardError
  end

  #
  # AuthorizationService
  #
  def authorize!(action, project=nil)
    if (authorize(action, project).nil?)
      name= project ? project.name : 'no project'
      raise AuthzException,
      "Not authorized for [#{action}:#{name}]",
      caller
      end
    end
  def authorize(action, project=nil)
    user_roles= retrieve_user_roles project

    # iterate the roles and for each find if it contains
    # the required permission for the requested action
    authorized_role= user_roles.find { |role|
      permissions= AUTHORIZATIONS[role]
      found= permissions.find {|permission|
        p= permission.to_sym
        p == '*' || action == p
      } if permissions

      !found.nil?
    }
    authorized_role
  end

  private
  def retrieve_user_roles(project)
    user= UserSession.find.user

    roles= []
    # roles as a user
    roles.<< user.role.to_sym if user.role
    # roles as a project member
    if (project)
      members= Member.find :all, :conditions => ['project_id=? and user_id=?', project.id, user.id]
      members.each { |m|
        roles << m.role.to_sym
      }
    end
    roles.<< :USER unless roles.include?(:USER)
    roles
  end
end
