require 'spec_helper'

describe Admin::UsersController do
  let(:user)         { mock_model(User) }
  let(:current_user) { stub(:user, admin: true) }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { current_user }
  end

  describe 'GET index' do
    it 'should assign all of the users' do
      User.should_receive(:all) { [user] }
      get :index
      assigns(:users).should == [user]
    end
  end

  describe 'GET show' do
    it 'should assign the user by :id' do
      User.should_receive(:find).with(user.id) { user }
      get :show, id: user.id
      assigns(:user).should == user
    end

    it 'should redirect if the user cannot be found' do
      User.should_receive(:find).with(user.id) { raise ActiveRecord::RecordNotFound }
      get :show, id: user.id
      flash[:notice].should == 'Sorry, but that user could not be found.'
      response.should redirect_to admin_users_path
    end
  end

  describe 'GET new' do
    it 'should assign a new user' do
      User.should_receive(:new) { user }
      get :new
      assigns(:user).should == user
    end
  end

  describe 'GET edit' do
    it 'should assign the user by :id' do
      User.should_receive(:find).with(user.id) { user }
      get :edit, id: user.id
      assigns(:user).should == user
    end

    it 'should redirect if the user cannot be found' do
      User.should_receive(:find).with(user.id) { raise ActiveRecord::RecordNotFound }
      get :edit, id: user.id
      flash[:notice].should == 'Sorry, but that user could not be found.'
      response.should redirect_to admin_users_path
    end
  end

  describe 'POST create' do
    it 'should create a new user, and redirect if it can save' do
      User.should_receive(:new) { user }
      user.should_receive(:save) { true }
      post :create
      flash[:success].should == 'New user was successfully created.'
      response.should redirect_to admin_users_path
    end

    it 'should re-render the "new" template if the user cannot be saved' do
      User.should_receive(:new) { user }
      user.should_receive(:save) { false }
      post :create
      assigns(:user).should == user
      response.should render_template 'new'
    end
  end

  describe 'PUT update' do
    it 'should update the user attributes and redirect if valid' do
      User.should_receive(:find).with(user.id) { user }
      user.should_receive(:update_attributes) { true }

      put :update, id: user.id
      flash[:success].should == 'User was successfully updated.'
      response.should redirect_to admin_users_path
    end

    it 'should re-render the "edit" template if the user cannot be updated' do
      User.should_receive(:find).with(user.id) { user }
      user.should_receive(:update_attributes) { false }

      put :update, id: user.id
      assigns(:user).should == user
      response.should render_template 'edit'
    end

    it 'should redirect if the user cannot be found' do
      User.should_receive(:find).with(user.id) { raise ActiveRecord::RecordNotFound }
      put :update, id: user.id
      flash[:notice].should == 'Sorry, but that user could not be found.'
      response.should redirect_to admin_users_path
    end
  end

  describe 'DELETE destroy' do
    it 'should delete the user by :id' do
      User.should_receive(:find).with(user.id) { user }
      user.should_receive(:destroy) { true }
      
      delete :destroy, id: user.id
      flash[:notice].should == 'User was successfully deleted.'
      response.should redirect_to admin_users_path
    end

    it 'should redirect if the user cannot be found' do
      User.should_receive(:find).with(user.id) { raise ActiveRecord::RecordNotFound }
      delete :destroy, id: user.id
      flash[:notice].should == 'Sorry, but that user could not be found.'
      response.should redirect_to admin_users_path
    end
  end
end
