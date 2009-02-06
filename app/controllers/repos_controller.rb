class ReposController < ApplicationController

  def git
    @repo = Repo.find(af_id(params))
    respond_to do |format|
      format.html{ render(:view => :git) }
    end
  end

  def enter
    @repo = Repo.find(af_id(params))
    @entries = @repo.entries
    @index = @entries.select{|f| f.match("^index")}.first
    @index = Page.find(File.join(@repo.path, @index)) if @index
    if @index
      redirect_to(af_path(:view, @index))
    else
      redirect_to(af_path(:git, @repo))
    end
  end

end
