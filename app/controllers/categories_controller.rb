class CategoriesController < ApplicationController
  before_filter :assign_categories
  before_filter :find_recent_posts

  def show
    @category = Category.find_with_posts_and_links(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: "Sorry, but the page you're looking for cannot be found."
  end
end
