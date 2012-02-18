require 'spec_helper'

describe Admin::CategoriesController do
  let(:category) { mock_model(Category) }
  let(:user)     { stub(:user, admin: true) }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { user }
  end

  describe 'GET index' do
    it 'should assign all categories' do
      Category.should_receive(:all) { [category] }
      get :index
      assigns(:categories).should == [category]
    end
  end

  describe 'GET new' do
    it 'should build a new category' do
      Category.should_receive(:new) { category }
      get :new
      assigns(:category).should == category
    end
  end

  describe 'GET edit' do
    it 'should assign the category by id' do
      Category.should_receive(:find).with(category.id) { category }
      get :edit, id: category.id
      assigns(:category).should == category
    end

    it 'should redirect to the categories_path if it cannot be found' do
      Category.stub(:find) { raise ActiveRecord::RecordNotFound }
      get :edit, id: category.id
      response.should redirect_to admin_categories_path
      flash[:error].should == 'Sorry, but that category could not be found.'
    end
  end

  describe 'POST create' do
    it 'should create a new category' do
      Category.should_receive(:new) { category }
      category.stub(:save) { true }
      post :create
      response.should redirect_to admin_categories_path
      flash[:success].should == 'Category was successfully created.'
    end

    it "should re-render the 'new' template if the category isn't valid" do
      Category.should_receive(:new) { category }
      category.stub(:save) { false }
      post :create
      response.should render_template(:new)
      assigns(:category).should == category
    end
  end

  describe 'PUT update' do
    it 'should destroy the category by :id' do
      Category.should_receive(:find).with(category.id) { category }
      category.should_receive(:destroy) { true }
      delete :destroy, id: category.id
      response.should redirect_to admin_categories_path
      flash[:notice].should == 'Category was successfully deleted.'
    end

    it 'should redirect to the categories_path if it cannot be found' do
      Category.stub(:find) { raise ActiveRecord::RecordNotFound }
      delete :destroy, id: category.id
      response.should redirect_to admin_categories_path
      flash[:error].should == 'Sorry, but that category could not be found.'
    end
  end

  describe 'DELETE destroy' do

  end
end
