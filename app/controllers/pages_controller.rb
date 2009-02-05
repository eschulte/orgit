class PagesController < ApplicationController
  before_filter(:login_required, :except => [:view, :history, :commit_view, :commit_diff, :commit_clear])
  
  def view
    @page = Page.find(af_id(params))
    respond_to do |format|
      format.html do
        render(:action => :view)
      end
      format.org { } # TODO: implement
      format.tex { } #TODO: implement
      format.any { send_data(File.read("#{File.join(Page.base_directory, path)}.#{params[:format]}")) }
    end
  end
  
  def history
    @page = Page.find(af_id(params))
    @history = @page.history
  end
  
  # change the following so that they work whether they are remote or
  # regular calls
  def edit_body
    @page = Page.find(params[:id])
    @body = @page.body
  end
  
  def update_body
    @page = Page.find(params[:id])
    @page.body = params[:body]
    if @page.save
      @body = @page.to_html()
      redirect_to(show_path(@page))
    else
      flash[:error] = @page.errors.full_messages.to_sentence
      @body = @page.to_html()
      redirect_to(show_path(@page))
    end
  end

  def commit_view
    @page = Page.find(params[:id])
    @sha  = params[:sha]
    @body = @page.at_revision(@sha)
    @html = Page.string_to_html(@body)
  end
  
  def commit_diff
    @page = Page.find(params[:id])
    puts :patton
    puts @page.path
    @sha  = params[:sha]
    @diff = @page.gcommit(@sha).diff_parent.path(@page.rel_path).html_patch
  end
  
  def commit_clear
    @sha = params[:sha]
  end
  
end
