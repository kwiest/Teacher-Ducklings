require 'spec_helper'

describe CategoriesController do
  describe 'GET show' do
    let(:category) { mock_model(Category) }

    it 'should assign the category and include posts' do
      Category.should_receive(:find_with_posts_and_links).with(category.id) { category }

      get :show, id: category.id
      assigns(:category).should == category
    end

    it 'should redirect if the category is not found' do
      Category.should_receive(:find_with_posts_and_links).with(category.id) { raise ActiveRecord::RecordNotFound }

      get :show, id: category.id
      response.should redirect_to root_path
      flash[:notice].should == "Sorry, but the page you're looking for cannot be found."
    end
  end
end
