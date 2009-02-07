class PagesController < ApplicationController
  before_filter(:login_required, :except => [:view, :history, :commit_view, :commit_diff, :commit_clear])

  def view
    path = af_id(params)
    @page = Page.find(path)
    @repo = @page.repo if @page
    respond_to do |format|
      format.html do
        render(:action => :view)
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
    @page = Page.find(af_id(params))
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
    @page = Page.find(af_id(params))
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
    @page = Page.find(af_id(params))
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

  def edit
    @page = Page.find(af_id(params))
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
    @page = Page.find(af_id(params))
    @page.body = params[:body]
    respond_to do |format|
      format.html do
        if @page.save
          redirect_to(af_path(:view, @page))
        else
          flash[:error] = @page.errors.full_messages.to_sentence
          redirect_to(af_path(:view, @page))
        end
      end
    end
  end

  def delete
    # TODO: implement page deletion in controller
  end

end
