class CategoriesController < ApplicationController

  def show
    load_model(Category)
  end
end
