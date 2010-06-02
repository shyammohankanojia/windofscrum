ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session

  map.connect 'menu', :controller => "menu", :action => "index"
#  map.connect 'burndown_charts/:id.:format', :controller => "burndown_charts", :action => "index",
#    :defaults => {:format => 'json'}

  #map.resources :projects do |project|
  map.resources :projects, :shallow => true do |project|
    project.resources :sprints, :member => {'update_estimated_focus_factor'=>:post} do |sprint|
      sprint.resources :backlog, :shallow => false, :only => [:index, :create, :destroy, :show], :member => {'change_state'=>:post}, :controller => "sprint_backlog", :singular => "story"
      sprint.resource :burndown, :shallow => false, :controller => "sprint_burndown", :action => "show", :defaults => {:format => 'json'}
      sprint.resource :progress, :shallow => false, :controller => "sprint_progress", :action => "show", :defaults => {:format => 'json'}
      sprint.resources :assignations, :shallow => false, :controller => "sprint_assignations"
    end
    project.resources :backlog, :singular => "story" do |story|
      story.resources :comments
    end
    project.resources :assigned_stories
  end



  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "welcome"


  # Install the default route as the lowest priority.
  #  map.connect ':controller/:action/:id.:format'
  #  map.connect ':controller/:action/:id'
end
