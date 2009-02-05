class ReposController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  
  def show()
    @repo = Repo.find(params[:id])
    @index = @repo.entries.select{|e| e.match("^index")}.first
    if @index
      redirect_to(show_path(Page.find(File.join(@repo.name, @index))))
    else
      @commit = @repo.last_commit
    end
  end
  
  def previous_commit
    @repo   = Repo.find(params[:id])
    @commit = @repo.gcommit(params[:sha]).parent
  end
  
end
