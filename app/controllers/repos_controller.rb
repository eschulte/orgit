class ReposController < ApplicationController

  def at
    @repo = Repo.find(params[:id])
    if @repo
      @at = File.join(params[:rest])
      path = File.join(@repo.path, @at)
      if ((not params[:dir_p]) and @page = (Page.find(path) or
                                            Page.find(File.join(path, File.basename(path)))))
        redirect_to(af_path(:view, @page))
      elsif @entries = @repo.entries(@at)
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
    @repo = Repo.find(af_id)
    @graph = @repo.git.lib.graph(:pretty => 'oneline').
      map{ |line| [$1, $2, $3] if line =~ /^([*| \\ \/]+)(\S+)(.+)$/ }
    respond_to do |format|
      format.html{ render(:view => :git) }
    end
  end

  def log
    @repo = Repo.find(af_id)
    @graph = @repo.git.lib.graph(:pretty => 'oneline').
      map{ |line| [$1, $2, $3] if line =~ /^([*| \\ \/]+)(\S+)(.+)$/ }
    if request.xhr?
      render(:partial => 'git_log', :locals => {:graph => @graph, :repo => @repo})
    else
      render(:action => :git)
    end
  end

  def commit
    @repo = Repo.find(af_id)
    @sha = params[:sha]
    @commit = @repo.gcommit(@sha)
    if request.xhr?
      render(:action => 'commit.rjs')
    end
  end

  def status
    @repo = Repo.find(af_id)
    @status = @repo.status
    if request.xhr?
      render(:partial => 'git_status', :locals => {:repo => @repo, :status => @status})
    else
      render(:action => :git)
    end
  end

  def branches
    @repo = Repo.find(af_id)
  end

  def grep
    @repo = Repo.find(af_id)
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
