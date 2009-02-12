class PagesController < ApplicationController
  include AuthenticatedSystem
  before_filter(:login_required, :only => [:commit_revert, :create, :edit, :update, :delete])

  def view
    path = af_id
    @page = Page.find(path)
    @repo = @page.repo if @page
    respond_to do |format|
      format.html do
        if @page
          render(:action => :view)
        else
          @path = path + ".org"
          @page = Page.find(@path)
          @repo = @page.repo if @page
          if @page
            render(:action => :view)
          else
            render(:action => 'new')
          end
        end
      end
      format.org do
        send_data(File.read(File.join(Page.base_directory, @page.path)),
                  :type => 'text/plain',
                  :disposition => 'attachment')
      end
      format.tex do
        send_data(@page.to_latex,
                  :type => 'text/plain',
                  :disposition => 'attachment')
      end
      format.any { send_data(File.read("#{File.join(Page.base_directory, path)}.#{params[:format]}")) }
    end
  end

  def history
    puts :patton
    puts af_id
    @page = Page.find(af_id)
    @history = @page.history
    if request.xhr?
      render(:action => 'history.rjs')
    else
      respond_to do |format|
        format.html do
          render(:action => 'history')
        end
      end
    end
  end

  def commit_view
    @page = Page.find(af_id)
    @sha  = params[:sha]
    @body = @page.at_revision(@sha)
    @html = Page.string_to_html(@body)
    if request.xhr?
      render(:action => 'commit_view.rjs')
    else
      respond_to do |format|
        format.html do
          render(:action => 'commit_view')
        end
      end
    end
  end

  def commit_diff
    @page = Page.find(af_id)
    @sha  = params[:sha]
    @diff = @page.gcommit(@sha).diff_parent.path(@page.rel_path).html_patch
    if request.xhr?
      render(:action => 'commit_diff.rjs')
    else
      respond_to do |format|
        format.html do
          render(:action => 'commit_diff')
        end
      end
    end
  end

  def commit_clear
    @sha = params[:sha]
  end

  # the following actions are only available to users who are logged in
  
  def commit_revert
    @page = Page.find(af_id)
    @sha  = params[:sha]
    @page.checkout_at(@sha)
    redirect_to(af_path(:view, @page))
  end
  
  def new
    @path = false
    @repo = params[:repo] ? Repo.find(params[:repo]) : false
  end
  
  def create
    begin
      path = (af_id.size > 0) ? (af_id + ".org") : params[:path]
      @page = Page.create(path)
      redirect_to(af_path(:view, @page))
    rescue
      flash[:error] = "<em>#{path}</em> is an invalid path for a new page"
      redirect_to(:controller => :welcome)
    end
  end

  def edit
    @page = Page.find(af_id)
    @body = @page.body
    if request.xhr?
      render(:action => 'edit.rjs')
    else
      respond_to do |format|
        format.html do
          render(:action => 'edit')
        end
      end
    end
  end

  def update
    @page = Page.find(af_id)
    @page.body = params[:body]
    respond_to do |format|
      format.html do
        if @page.save_and_commit(params[:commit])
          redirect_to(af_path(:view, @page))
        else
          flash[:error] = @page.errors.full_messages.to_sentence
          redirect_to(af_path(:view, @page))
        end
      end
    end
  end

  def delete
    @page = Page.find(af_id)
    @repo = @page.repo
    if @page.destroy_and_commit("deleting #{@page.rel_path}")
      redirect_to(af_path(:at, @repo))
    else
      flash[:error] = @page.errors.full_messages.to_sentence
      redirect_to(af_path(:view, @page))
    end
  end

end
