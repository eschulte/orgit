class AdminController < ApplicationController
  before_filter :login_required
  before_filter :check_for_admin
  
  # TODO: from here we can handle the creation, renaming, and
  #       destruction of repos, as well as the maintenance of users
  #       and privileges etc...
  #
  # - repo crud
  # - user approval
  # - repo customization (through a yaml file saved inside of the repo)
  
end
