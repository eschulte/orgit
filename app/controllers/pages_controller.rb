class PagesController < ApplicationController
  before_filter(:login_required,
                :except => [:index, :show, :history, :commit_view, :commit_diff, :commit_clear])
  
  def index
    path = path_from_params(params)
    respond_to do |format|
      format.html do
        @page = Page.find(path)
        render(:action => :show)
      end
      format.any { send_data(File.read("#{File.join(Page.base_directory, path)}.#{params[:format]}")) }
    end
  end
  
  def show
    if params[:rest]
      send_data(File.read(File.join(Page.base_directory, params[:rest].join("/"))))
    end
    @page = Page.find(params[:id])
  end
  
  def new
    @page = Page.new(params[:path])
  end
  
  def edit
    @page = Page.find(params[:id])
  end
  
  def create
    @page = Page.create(params[:page])
    if @page.save
    else
    end
  end
  
  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    if @page.save
    else
    end
  end
  
  # remotes
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
  
  def history
    @page = Page.find(params[:id])
    @history = @page.history
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
