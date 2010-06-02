require 'authorization/authz'

module AuthzHelper
  include Authz
  
  def authorized_for(action, project)
    authorize action, project
  end

  # @return true/false
  def authz_to_update_story(project)
   authorized_for(:UPDATE_STORY, project)
  end

end