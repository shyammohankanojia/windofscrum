require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class AssignedStoriesController; def rescue_action(e) raise e end; end

class AssignedStoriesControllerTest < ActionController::TestCase

  test 'index_should_return_a_map' do
    UserSession.create(users(:oliver))
    get 'index', {:project_id => 1}

    assert_response :success
    assert assigns["assigned_stories"]
  end
end
