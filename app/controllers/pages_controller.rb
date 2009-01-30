class PagesController < ApplicationController
  before_filter :login_required, :except => :index
  
  def index
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
  
end
