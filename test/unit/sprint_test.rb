require File.dirname(__FILE__) + '/../test_helper'

class SprintTest < ActiveSupport::TestCase

  DEFAULT_AVAILABLE_MAN_DAYS = 10
  DEFAULT_ESTIMATED_FOCUS_FACTOR= 0.75

  # 
  def test_actual_velocity

    # without stories
    sprint= Sprint.new
    assert_equal 0, sprint.actual_velocity

    # with non-estimated stories
    non_estimated_story = backlog(:non_estimated)
    sprint.backlog.<<(backlog(:create_slide), backlog(:slide_performance), non_estimated_story)
    assert_equal 17, sprint.actual_velocity

    # with full estimated stories
    non_estimated_story.initial_estimate= 3
    assert_equal 20, sprint.actual_velocity

    # with unfinished stories
    sprint.backlog.<<(backlog(:unfinished))
    assert_equal 20, sprint.actual_velocity
  end

  def test_get_last_sprint
    UserSession.create users(:marc)

    project= projects(:autoronda)
    sprint= project.sprints.create(:name => 'last')
    assert_equal sprint, sprint.get_last_sprint

    sprint= project.sprints.create(:name=> 'new last')
    project.save()
    assert_equal sprint, project.sprints.last.get_last_sprint
  end

  def test_update_estimated_focus_factor
    UserSession.create users(:crodella)

    sprint= projects(:windsofscrum).sprints.build({:name => 'last',
      :release_date => Time.new.to_s(:db), :available_man_days=> 10,
      :finished => false})
    assert sprint.errors.empty?
    sprint.update_estimated_focus_factor()
    assert_equal 0, sprint.estimated_focus_factor

    last_sprint= sprints(:app_skeleton)
    last_sprint.finished= true
    last_sprint.save!
    sprint.project.sprints true
    sprint.update_estimated_focus_factor
    assert_equal 34, sprint.estimated_focus_factor
  end

#  def test_focus_factor_in_tant_per_one
#    sprint= sprints(:app_skeleton)
#    assert '2345', sprint.ff
#  end
  def test_focus_factor_returns_nil_if_sprint_has_not_finished
    sprint= sprints(:app_skeleton)
    assert_nil sprint.focus_factor
  end
  
  def test_focus_factor_returns_nil_if_sprint_has_not_all_needed_information
    sprint= sprints(:app_skeleton)
    sprint.finished= true
    sprint.available_man_days= 0
    assert_nil sprint.focus_factor
  end

  def test_focus_factor_is_computed
    sprint= sprints(:app_skeleton)
    # invoke accessor to get stories loaded
    sprint.backlog
    sprint.finished= true
    assert_equal 0.34, sprint.focus_factor
  end

  def test_can_estimate_velocity
    sprint= Sprint.new
    sprint.available_man_days= DEFAULT_AVAILABLE_MAN_DAYS
    sprint.estimated_focus_factor= DEFAULT_ESTIMATED_FOCUS_FACTOR
    assert sprint.can_estimate_velocity
  end

  def test_can_not_estimate_velocity
    sprint= Sprint.new
    assert ! sprint.can_estimate_velocity
 
    sprint.available_man_days= DEFAULT_AVAILABLE_MAN_DAYS
    assert ! sprint.can_estimate_velocity

    sprint.available_man_days= 0
    sprint.estimated_focus_factor= DEFAULT_ESTIMATED_FOCUS_FACTOR
    assert ! sprint.can_estimate_velocity
  end

  def test_estimate_velocity
    sprint= Sprint.new
    begin
      sprint.estimate_velocity
      fail
    rescue
    end

    sprint.available_man_days= DEFAULT_AVAILABLE_MAN_DAYS
    sprint.estimated_focus_factor= DEFAULT_ESTIMATED_FOCUS_FACTOR
    assert_equal 7.5, sprint.estimate_velocity
  end

  def test_remaining_work_on_date
    date = Time.parse('2009/09/01')
    assert_equal 10, sprints(:app_skeleton).remaining_work_on_date(date)
    date = Time.parse('2009/08/30')
    assert_equal 25, sprints(:app_skeleton).remaining_work_on_date(date)
    date = Time.parse('2009/08/10')
    assert_equal 27, sprints(:app_skeleton).remaining_work_on_date(date)
    date = Time.parse('2009/07/27')
    assert_equal 27, sprints(:app_skeleton).remaining_work_on_date(date)
  end
end
