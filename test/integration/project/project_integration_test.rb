# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test_helper'

class ProjectIntegrationTest < ActiveSupport::TestCase

  def test_should_create_project
    UserSession.create users(:oliver)
    o= users(:oliver).id
    m= users(:crodella).id
    t= [users(:ferran).id, users(:marc).id]
    p= Project.create({'name' => 'project_name'},
      {:product_owner=>o,
      :scrum_master=>m,
      :team=>t})
    assert p
    assert_equal(Project, p.class)
    assert_not_nil p.id
    check_pigs(o, m, t, p)
  end

  def test_should_assotiate_pigs
    o= users(:crodella).id
    m= users(:ferran).id
    t= [users(:oliver).id, users(:marc).id]
    p= projects(:autoronda)
    p.set_pigs({:product_owner=>o,
      :scrum_master =>m,
      :team =>t})
    assert p.errors.empty?
    check_pigs(o, m, t, p)
  end

  def test_should_update_project
    UserSession.create users(:oliver)
    p= projects(:windsofscrum)
    o= users(:marc).id
    m= users(:ferran).id
    t= [users(:crodella).id, users(:oliver).id]
    p.update_props({'name' => 'Windsofscrum renamed'},
      {:product_owner=>o,
      :scrum_master=>m,
      :team=>t})
    assert 'Windsofscrum renamed', p.name
    check_pigs o, m , t, p
  end

  def test_should_destroy_project
    UserSession.create users(:crodella)
    p= projects(:windsofscrum)
    assert_nothing_raised {
      p.destroy
    }
  end

  def test_should_denegate_permission
    UserSession.create users(:marc)
    p= projects(:windsofscrum)
    begin
      p.update_props({'name' => 'never set'})
      flunk(":marc should not be authorized to update :windsofscrum.")
    rescue #expected
    end
    begin
      p.destroy
      flunk(":marc should not be authorized to destroy :windsofscrum.")
    rescue #expected
    end
  end

  def test_should_build_and_update_sprint_with_authorization
    UserSession.create users(:marc)

    p= projects(:autoronda)
    now= Time.new
    s= p.build_sprint({:name => 'Test sprint builds', :release_date => now, :available_man_days => 10, :estimated_focus_factor => 0.80})
    p.save!()
    s= p.sprints.find(:first)
    check_sprint(s, 'Test sprint builds', now, 10, 0.80)

    now= Time.now
    s.update_attributes({:name => 'Test sprint updates', :release_date => now, :available_man_days => 11, :estimated_focus_factor => 0.75})
    check_sprint(s, 'Test sprint updates', now, 11, 0.75)
  end
  def test_authorizations_on_sprints
    UserSession.create users(:ferran)

    begin
      projects(:windsofscrum).build_sprint({})
      flunk(":ferran should not be able to build a sprint for :windsofscrum.")
    rescue Authz::AuthzException
    end
    begin
      sprints(:app_skeleton).update_attributes({})
      flunk(":ferran should not be able to update :app_skeleton.")
    rescue Authz::AuthzException
    end
    begin
      sprints(:app_skeleton).backlog << backlog(:create_slide)
      flunk(":ferran should not be able to assign stories to :app_skeleton.")
    rescue Authz::AuthzException
    end
    begin
      sprints(:app_skeleton).destroy
      flunk(":ferran should not be able to destroy :app_skeleton.")
    rescue Authz::AuthzException
    end

  end

  def check_sprint(sprint, name, release_date, man_days, focus_factor)
    assert sprint
    assert name, sprint.name
    assert release_date, sprint.release_date
    assert man_days, sprint.available_man_days
    assert focus_factor, sprint.estimated_focus_factor
  end
  def test_should_build_and_update_story
    UserSession.create users(:marc)
    p= projects(:autoronda)
    s= p.build_story({:name => 'Test the story builds', :importance => 10, :initial_estimate => 0, :how_to_demo => 'Check the test succeeds'})
    p.save!()
    s= p.backlog.find(:first)
    check_story(s, 'Test the story builds', 10, 0, 'Check the test succeeds')

    s.update_attributes({:name => 'Test the story updates', :importance => 9, :initial_estimate => 1})
    check_story(s, 'Test the story updates', 9, 1, 'Check the test succeeds')
  end
  def test_should_assign_story
    UserSession.create users(:oliver)
    sprint= sprints(:app_skeleton)
    old_backlog_size= sprint.backlog.size
    story= projects(:windsofscrum).backlog.find(:first, :conditions => 'sprint_id is null')
    sprint.backlog << story
    assert sprint, story.sprint
    assert old_backlog_size + 1, sprint.backlog
  end
  def test_should_unassign_story
    UserSession.create users(:oliver)
    sprint= sprints(:app_skeleton)
    story= sprint.backlog.first
    old_backlog_size= sprint.backlog.size
    sprint.backlog.delete story
    assert old_backlog_size -1, sprint.backlog.size
  end

  def test_authorizations_on_stories
    UserSession.create users(:ferran)

    begin
      Story.new({:name=>'Unauthorized', :importance=>0, :project_id=>projects(:windsofscrum).id}).save()
      flunk(":ferran should not be able to build a story for project :windsofscrum.")
    rescue Authz::AuthzException
    end
    begin
      backlog(:unfinished).update_attributes({})
      flunk(":ferran should not be able to update story :unfinished.")
    rescue Authz::AuthzException
    end
    begin
      backlog(:unfinished).destroy
      flunk(":ferran should not be able to destroy story :unfinished.")
    rescue Authz::AuthzException
    end

  end

  private
  def check_story(s, name, importance, estimate, howto)
    assert s
    assert_equal name, s.name
    assert_equal importance, s.importance
    assert_equal estimate, s.initial_estimate
    assert_equal howto, s.how_to_demo
  end
  def check_pigs(o, m, t, p)
    assert_equal o, p.product_owner.user_id
    assert_equal m, p.scrum_master.user_id
    p.team.each do |tm|
      assert tm.errors.empty?
      assert t.include?(tm.user_id)
    end
  end
end
