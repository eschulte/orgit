class AdminController < ApplicationController
  before_filter :login_required
  before_filter :check_for_admin
  
  # from here we can handle the creation, renaming, and destruction of wikis
  
end
