class ReposController < ApplicationController

  def git
    @repo = Repo.find(af_id(params))
  end

  def enter
    @repo = Repo.find(af_id(params))
    @entries = @repo.entries
    @index = @entries.select{|f| f.match("^index")}.first
    @index = Page.find(File.join(@repo.path, @index))
    if @index
      redirect_to(af_path(:view, @index))
    else
      render(:view => :enter)
    end
  end

end
