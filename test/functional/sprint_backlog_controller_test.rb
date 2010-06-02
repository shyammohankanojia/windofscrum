require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class SprintBacklogController; def rescue_action(e) raise e end; end

class SprintBacklogControllerTest < ActionController::TestCase

  def setup
    UserSession.create(users(:oliver))
  end

  def test_destroy
    sprint= sprints(:app_skeleton)

    assigned_story= nil
    assert_nothing_raised {
      assigned_story= sprint.backlog.first
    }
    assert assigned_story
    id= assigned_story.id
    post :destroy, :id => id, :sprint_id => sprint.id

    #assert_response :success
    assert_redirected_to  sprint_backlog_path(sprint)
    assert_nil sprint.backlog(true).detect(nil) { |s| s.id == id }
  end

end
