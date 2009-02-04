class PagesController < ApplicationController
  before_filter(:login_required,
                :except => [:index, :show, :history, :commit_view, :commit_diff, :commit_clear])
  
  def index
    if params[:rest]
      id = params[:rest].join("/")
      puts "id=#{id}"
      @page = Page.find(id)
      unless @page
        send_data(File.read(File.join(Page.base_directory, id)))
      end
    else
      @page = Page.find(params[:id])
    end
    render(:action => :show) if @page
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
      render(:action => :show)
    else
      flash[:error] = @page.errors.full_messages.to_sentence
      @body = @page.to_html()
      render(:action => :show)
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
    @sha  = params[:sha]
    @diff = @page.gcommit(@sha).diff_parent.html_patch
  end
  
  def commit_clear
    @sha = params[:sha]
  end
  
end
