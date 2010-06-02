require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  fixtures :users

#  def test_should_get_index
#    UserSession.create(users(:oliver))
#    get 'index'
#    assert_response :success
#    assert assigns(:users)
#  end

  def test_should_get_new
    UserSession.create(users(:oliver))

    get 'new'
    assert_response :success
  end
  
  def test_should_create_user
    UserSession.create(users(:oliver))

    old_count = User.count
    post 'create', :user => {:name=>'username', :login=>'userlogin', :email=>'test@email.net',
      :password=>'passwd', :password_confirmation=>'passwd'}
    assert_equal old_count+1, User.count
    
    assert_redirected_to account_path
  end

  def test_should_show_user
    UserSession.create(users(:oliver))
    get 'show', :id => 1
    assert_response :success
  end

  def test_should_get_edit
    UserSession.create(users(:oliver))
    get 'edit', :id => 1
    assert_response :success
  end
  
#  def test_should_update_user
#    put 'update', :id => 1, :user => { }
#    assert_redirected_to user_path(assigns(:user))
#  end
  
#  def test_should_destroy_user
#    old_count = User.count
#    delete 'destroy', :id => 1
#    assert_equal old_count-1, User.count

#    assert_redirected_to users_path
#  end
end
