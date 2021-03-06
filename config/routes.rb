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
  map.connect 'at/:id/*rest', :controller => 'repos', :action => 'at'
  map.connect 'git/*rest', :controller => 'repos', :action => 'git'
  map.connect 'log/*rest', :controller => 'repos', :action => 'log'
  map.connect 'status/*rest', :controller => 'repos', :action => 'status'
  map.connect 'branches/*rest', :controller => 'repos', :action => 'branches'
  map.connect 'grep/*rest', :controller => 'repos', :action => 'grep'
  map.connect 'commit/*rest', :controller => 'repos', :action => 'commit'
  
  # pages (viewing and editing pages)
  map.connect ':action/*rest.:format', :controller => 'pages'
  map.connect ':action/*rest', :controller => 'pages', :format => 'html'
end
