# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test_helper'
require 'authorization/authz'


class AuthzTest < ActiveSupport::TestCase

  def setup
    activate_authlogic
    @authz= Authz::Service.new
  end
  def test_should_authz
    UserSession.create(users(:oliver))
    assert @authz.authorize(:CREATE_PROJECT)
    assert @authz.authorize(:UPDATE_PROJECT, projects(:windsofscrum) )
    UserSession.find.destroy

    UserSession.create(users(:ferran))
    assert @authz.authorize(:CREATE_PROJECT)
    assert @authz.authorize(:CREATE_STORY, projects(:autoronda))
  end
  def test_should_not_authz
    UserSession.create(users(:ferran))
    assert !@authz.authorize(:UPDATE_PROJECT, projects(:windsofscrum))
    UserSession.find.destroy
    UserSession.create(users(:crodella))
    assert !@authz.authorize(:UPDATE_PROJECT_MEMBERS, projects(:windsofscrum))
  end
  def test_should_raise_exception
    UserSession.create(users(:ferran))
    begin
      @authz.authorize!(:CREATE_SPRINT, projects(:autoronda))
      flunk("Authorization exception expected.")
    rescue Authz::AuthzException
    end
  end
end
