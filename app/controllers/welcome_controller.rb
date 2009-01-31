class WelcomeController < ApplicationController
  
  def index()
    @repos = Repo.all
  end
  
end
