class CategoriesController < ApplicationController
before_action :require_login, only: [:new, :create, :edit, :update]

  def index
    @cat = Category.all
  end
  def show
    @category = Category.find(params[:id])
  end
  def new
    
  end
  def create
    
  end
  def edit
    
  end
  def update
    
  end
end
