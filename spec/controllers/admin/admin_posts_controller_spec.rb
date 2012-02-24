require 'spec_helper'

describe Admin::PostsController do
  let(:post_model) { mock_model(Post) }
  let(:user)       { stub(:user, admin: true) }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { user }
  end

  describe 'GET index' do
    it 'should assign all posts' do
      Post.should_receive(:all) { [post_model] }
      get :index
      assigns(:posts).should == [post_model]
    end
  end

  describe 'GET show' do
    it 'should assign the post by :id' do
      Post.should_receive(:find).with(post_model.id.to_s) { post_model }
      get :show, id: post_model.id
      assigns(:post).should == post_model
    end

    it 'should redirect if the post cannot be found' do
      Post.should_receive(:find).with(post_model.id.to_s) { raise ActiveRecord::RecordNotFound }
      get :show, id: post_model.id
      flash[:notice].should == 'Sorry, but we cannot find that post.'
      response.should redirect_to admin_posts_path
    end
  end

  describe 'GET new' do
    it 'should create and assign a new Post' do
      Post.should_receive(:new) { post_model }
      get :new
      assigns(:post).should == post_model
    end
  end

  describe 'GET edit' do
    it 'should assign the post by :id' do
      Post.should_receive(:find).with(post_model.id.to_s) { post_model }
      get :edit, id: post_model.id
      assigns(:post).should == post_model
    end

    it 'should redirect if the post cannot be found' do
      Post.should_receive(:find).with(post_model.id.to_s) { raise ActiveRecord::RecordNotFound }
      get :edit, id: post_model.id
      flash[:notice].should == 'Sorry, but we cannot find that post.'
      response.should redirect_to admin_posts_path
    end
  end

  describe 'POST create' do
    it 'should create a new post if valid and redirect to admin_posts_path' do
      Post.should_receive(:new) { post_model }
      post_model.should_receive(:save) { true }
      post :create
      flash[:success].should == 'Post was successfully published.'
      response.should redirect_to admin_posts_path
    end

    it 'should re-render the "new" template if the post cannot save' do
      Post.should_receive(:new) { post_model }
      post_model.should_receive(:save) { false }
      post :create
      assigns(:post).should == post_model
      response.should render_template "new"
    end
  end

  describe 'PUT update' do
    it 'should update the attributes of the post and redirect to admin_posts_path' do
      Post.should_receive(:find).with(post_model.id.to_s) { post_model }
      post_model.should_receive(:update_attributes) { true }
      put :update, id: post_model.id
      flash[:success].should == 'Post was successfully updated and published.'
      response.should redirect_to admin_posts_path
    end

    it 'should re-render the "edit" template if the post cannot update its attributes' do
      Post.should_receive(:find).with(post_model.id.to_s) { post_model }
      post_model.should_receive(:update_attributes) { false }
      put :update, id: post_model.id
      assigns(:post).should == post_model
      response.should render_template 'edit'
    end

    it 'should redirect if the post cannot be found' do
      Post.should_receive(:find).with(post_model.id.to_s) { raise ActiveRecord::RecordNotFound }
      put :update, id: post_model.id
      flash[:notice].should == 'Sorry, but we cannot find that post.'
      response.should redirect_to admin_posts_path
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the post by :id and redirect to admin_posts_path' do
      Post.should_receive(:find).with(post_model.id.to_s) { post_model }
      post_model.should_receive(:destroy) { true }
      delete :destroy, id: post_model.id
      flash[:notice].should == 'Post was successfully deleted.'
      response.should redirect_to admin_posts_path
    end

    it 'should redirect if the post cannot be found' do
      Post.should_receive(:find).with(post_model.id.to_s) { raise ActiveRecord::RecordNotFound }
      delete :destroy, id: post_model.id
      flash[:notice].should == 'Sorry, but we cannot find that post.'
      response.should redirect_to admin_posts_path
    end
  end
end
