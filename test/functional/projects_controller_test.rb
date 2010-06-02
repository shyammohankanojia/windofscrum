require 'test_helper'

# Re-raise errors caught by the controller.
class ProjectsController; def rescue_action(e) raise e end; end

class ProjectsControllerTest < ActionController::TestCase

  def setup
    UserSession.create(users(:oliver))
    @first_id = projects(:windsofscrum).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'projects/index.rhtml'
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:project)
    assert assigns(:project).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:project)
  end

  def test_create
    num_projects = Project.count

    post :create, :project => {:name=>'test_create',:product_owner => users(:oliver).id,
      :scrum_master=>users(:oliver).id,:team=>[users(:oliver).id,users(:crodella).id]}

    actual= Project.find(:last)
    assert actual.product_owner
    assert actual.scrum_master
    assert_equal 2, actual.team.size()

    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert_equal num_projects + 1, Project.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:project)
    assert assigns(:project).valid?
  end

  def test_update
    UserSession.create users(:crodella)
    post :update, :id => @first_id, :project => {:name=>'test_create',:product_owner => users(:crodella).id,:scrum_master=>users(:crodella).id,:team=>[users(:marc).id,users(:ferran).id]}

    actual= Project.find(@first_id)
    assert_equal 'test_create', actual.name

    o= actual.product_owner
    assert_equal users(:crodella), User.find(o.user_id)
    m= actual.scrum_master
    assert_equal users(:crodella), User.find(m.user_id)
    team= actual.team
    expected_team= [users(:ferran).id, users(:marc).id]
    actual_team= team.collect {|m| m.user_id }
    assert_equal expected_team.size(), actual_team.size()
    expected_team.each { |item|
      assert actual_team.delete(item)
    }
    assert actual_team.empty?

    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    UserSession.create users(:crodella)
    assert_nothing_raised {
      p= Project.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) {
      Project.find(@first_id)
    }
  end

end
