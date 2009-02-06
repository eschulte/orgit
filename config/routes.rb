ActionController::Routing::Routes.draw do |map|

  # landing page of the wiki
  map.root :controller => 'welcome'
  
  # user maintenance 
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session

  # admin (administration of the wiki)
  map.connect 'admin/:action/:id', :controller => 'admin'
  
  # repos (viewing the meta information of a repo)
  map.connect 'git/*rest', :controller => 'repos', :action => 'git'
  map.connect 'enter/*rest', :controller => 'repos', :action => 'enter'
  
  # pages (viewing and editing pages)
  map.connect ':action/*rest.:format', :controller => 'pages'
  map.connect ':action/*rest', :controller => 'pages', :format => 'html'
end
