require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class BacklogController; def rescue_action(e) raise e end; end

class BacklogControllerTest < ActionController::TestCase

  def setup
    UserSession.create(users(:oliver))
  end

  def test_should_get_index
    get :index, :project_id => projects(:windsofscrum).id
    assert_response :success
    assert assigns(:backlog)
  end

  def test_should_get_new
    get :new, :project_id => projects(:windsofscrum).id
    assert_response :success
  end
  
  def test_should_create_story
    old_count = Story.count
    p= projects(:windsofscrum)
    post :create, :story => {:name => 'Should create backlog', :importance => 10}, :project_id => p.id

    assert_equal old_count+1, Story.count
  end

  def test_should_create_assigned_story
    old_count = Story.count
    p= projects(:windsofscrum)
    sprint= sprints(:app_skeleton)
    post :create, :story => {:name => 'Should create and assign story', :sprint_id => sprint.id, :importance => 10}, :project_id => p.id

    assert_equal old_count+1, Story.count
    story= Story.find(:first, :conditions => ['name=?', 'Should create and assign story'])
    assert_equal sprint, story.sprint
  end

  def test_should_show_backlog
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_backlog
    story= Story.find 1
    put :update, :id => story.id, :story => { }
    assert_redirected_to  story_path(story)
  end

  def test_should_update_story_user
    story= Story.find 1
    crodella= users(:crodella)
    put :update, :id => story.id, :story => {:user_id => crodella.id }
    assert_redirected_to  story_path(story)
    assert_equal crodella.id, Story.find(1).user.id
  end
 
  def test_should_destroy_backlog
    old_count = Story.count
    story= Story.find 1
    delete :destroy, :id => story.id
    assert_equal old_count-1, Story.count
    
    assert_redirected_to project_backlog_url(story)
  end
end
