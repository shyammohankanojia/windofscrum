require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class SprintsController; def rescue_action(e) raise e end; end

class SprintsControllerTest < ActionController::TestCase

  def setup
    UserSession.create(users(:oliver))
    @first_id = sprints(:app_skeleton).id
  end

  def test_index
    get :index, :project_id => projects(:windsofscrum).id
    assert_response :success
    assert_template 'index'
  end

  def test_show
    get :show, :id => @first_id, :project_id => projects(:windsofscrum).id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:sprint)
    assert assigns(:sprint).valid?
  end

  def test_new
    get :new, :project_id => projects(:windsofscrum).id

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:sprint)
  end

  def test_create
    num_sprints = Sprint.count

    project_id= projects(:windsofscrum).id
    post :create, :sprint => {:name => 'default name', :project_id => project_id}, :project_id => project_id

    assert_response :redirect
    assert_redirected_to :action => 'index'

    assert_equal num_sprints + 1, Sprint.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:sprint)
    assert assigns(:sprint).valid?
  end

  def test_update
    post :update, :id => @first_id, :project_id => projects(:windsofscrum).id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Sprint.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) {
      Sprint.find(@first_id)
    }
  end
end
