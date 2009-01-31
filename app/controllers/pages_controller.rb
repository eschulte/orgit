class PagesController < ApplicationController
  before_filter :login_required, :except => :index
  
  def index
    @page = Page.find(params[:id])
  end
  
  def show
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
    @page = Page.get(params[:id])
    @body = @page.body
  end
  
  def update_body
    @page = Page.get(params[:id])
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
  
end
