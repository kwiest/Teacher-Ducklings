require 'spec_helper'

describe Admin::CommentsController do
  let(:user)    { stub(:user, admin: true) }
  let(:post)    { mock_model(Post) }
  let(:comment) { mock_model(Comment) }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { user }
  end

  describe 'DELETE destroy' do
    it 'should destroy the comment by :id' do
      Post.should_receive(:find).with(post.id) { post }
      post.stub_chain(:comments, :find) { comment }
      comment.should_receive(:destroy) { true }

      delete :destroy, post_id: post.id, id: comment.id
      response.should redirect_to admin_post_path(post)
      flash[:notice].should == 'Comment successfully deleted.'
    end

    it 'should redirect if the post cannot be found' do
      Post.should_receive(:find).with(post.id) { raise ActiveRecord::RecordNotFound }

      delete :destroy, post_id: post.id, id: comment.id
      response.should redirect_to admin_posts_path
      flash[:error].should == "Sorry, but we could not find what you're looking for."
    end

    it 'should redirect if the comment cannot be found' do
      Post.should_receive(:find).with(post.id) { post }
      post.stub_chain(:comments, :find) { raise ActiveRecord::RecordNotFound }

      delete :destroy, post_id: post.id, id: comment.id
      response.should redirect_to admin_posts_path
      flash[:error].should == "Sorry, but we could not find what you're looking for."
    end
  end
end
