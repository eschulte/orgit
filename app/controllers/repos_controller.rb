class ReposController < ApplicationController

  def at
    @repo = Repo.find(params[:id])
    if @repo
      @at = File.join(params[:rest])
      if @entries = @repo.entries(@at)
        @entries = @entries.reject{|e| e.match("^\\.")}
        @index = @entries.select{|f| f.match("^index")}.first
        @index = Page.find(File.join(@repo.path, @at, @index)) if @index
        if @index
          redirect_to(af_path(:view, @index))
        else
          render(:view => :at)
        end
      else
        redirect_to(af_path(:view, File.join(@repo.path, @at)))
      end
    else
      redirect_to(:controller => :welcome)
    end
  end

  def git
    @repo = Repo.find(af_id(params))
    respond_to do |format|
      format.html{ render(:view => :git) }
    end
  end

  def grep
    @repo = Repo.find(af_id(params))
    @query = params[:query]
    @results = @repo.grep(@query) if @query
    if request.xhr?
      render(:action => 'grep.rjs')
    else
      respond_to do |format|
        format.html{ render(:view => 'grep.html') }
      end
    end
  end

end
