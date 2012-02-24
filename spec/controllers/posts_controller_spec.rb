require 'spec_helper'

describe PostsController do
  let(:post_model) { mock_model(Post) }

  describe 'GET index' do
    before do
      Post.should_receive(:all) { [post_model] }
    end

    it 'should assign all posts' do
      get :index
      assigns(:posts).should == [post_model]
    end

    it 'should render a feed if the content-type is Atom' do
      get :index, format: :atom
      assigns(:posts).should == [post_model]
      response.headers['Content-Type'].should == 'application/atom+xml; charset=utf-8'
    end
  end
  
  describe 'GET show' do
    it 'should get the post by :id' do
      Post.should_receive(:find).with(post_model.id.to_s) { post_model }
      get :show, id: post_model.id
      assigns(:post).should == post_model
    end

    it 'should redirect if the post cannot be found' do
      Post.should_receive(:find).with(post_model.id.to_s) { raise ActiveRecord::RecordNotFound }
      get :show, id: post_model.id
      flash[:notice].should == "Sorry, but the post you're looking for cannot be found."
      response.should redirect_to root_path
    end
  end
end
