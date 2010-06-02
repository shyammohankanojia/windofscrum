require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < ActionController::TestCase

  def setup
    UserSession.create(users(:oliver))
  end

  # Replace this with your real tests.
  def test_create_adds_user_name_and_creation_date
    old_count = Comment.count

    post :create, :comment => {:title => 'test_case_comment', :text => 'The test_case_comment text.'}, :story_id => 2

    new_comment= Comment.find(:first, :conditions => ['title=?', 'test_case_comment'])
    assert_equal old_count+1, Comment.count
    assert_equal "oliver.hv", new_comment.user_name
    assert new_comment.creation_date <= Time.now

    assert_redirected_to comment_url(new_comment)
  end
end
