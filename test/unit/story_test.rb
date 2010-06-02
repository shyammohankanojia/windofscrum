require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < ActiveSupport::TestCase
  def test_should_update_end_date_on_finish
    UserSession.create users(:crodella)

    story= backlog(:unassigned)
    assert_nil story.end_date
    story.finished= true
    assert story.save()
    assert_not_nil story.end_date

    story.finished= false
    yesterday= Time.new - 1.days
    story.end_date= yesterday
    assert story.save()
    
    story.finished= true
    assert story.save()
    assert yesterday < story.end_date
  end

  def test_checking_of_pending_state
    UserSession.create users(:crodella)
    story= backlog(:unassigned)

    # is pending
    story.finished= false
    story.user= nil
    assert story.pending?()

    # is not pending
    story.finished= true
    assert !story.pending?()
    story.finished= false
    story.user= users(:crodella)
    assert !story.pending?()
  end
  def test_checking_of_workingonit_state
    UserSession.create users(:crodella)
    story= backlog(:unassigned)

    #is working on it
    story.finished= false
    story.user= users(:crodella)
    assert story.workingonit?()

    # is not working on it
    story.finished= false
    story.user= nil
    assert !story.workingonit?()
    story.finished= true
    story.user= users(:crodella)
    assert !story.workingonit?()
  end
  def test_checking_of_finished_state
    UserSession.create users(:crodella)
    story= backlog(:unassigned)

    #is finished
    story.finished= true
    story.user= users(:crodella)
    assert story.finished?()
    story.user= nil
    assert story.finished?()

    # is not finished
    story.finished= false
    assert !story.finished?()
    story.user= users(:crodella)
    assert !story.finished?()
  end

  def test_should_move_to_pending_state
    UserSession.create users(:crodella)
    story= backlog(:workingonit)
    assert story.workingonit?()
    story.to_pending()
    assert story.pending?()
    assert_nil story.end_date

    story= backlog(:create_slide)
    story.end_date= Time.new
    assert story.finished?()
    story.to_pending()
    assert story.pending?()
    assert_nil story.end_date
  end

  def test_should_move_to_workingonit_state
    UserSession.create users(:crodella)
    story= backlog(:unassigned)
    assert story.pending?()
    story.to_workingonit(users(:crodella).id)
    assert story.workingonit?()
    assert_equal users(:crodella), story.user
    story.finished= true
    assert story.finished?()
    story.to_workingonit()
    assert story.workingonit?()
    assert_equal users(:crodella), story.user
  end

  def test_should_move_to_finished_state
    UserSession.create users(:crodella)
    story= backlog(:unassigned)
    assert story.pending?()
    story.to_finished()
    assert story.finished?()

    story= backlog(:workingonit)
    assert story.workingonit?()
    story.to_finished()
    assert story.finished?()
  end
end
