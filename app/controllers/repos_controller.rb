class ReposController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  
  def show()
    @repo = Repo.find(params[:id])
  end
  
end
