class CategoriesController < ApplicationController

  def show
    @category = load_model(Category)
  end
end
