require 'spec_helper'

describe CommentsController do
  describe 'POST create' do
    let(:post_model) { mock_model(Post) }
    let(:comment)    { stub }

    before do
      Post.stub(:find) { post_model }
    end

    it 'should save a comment and redirect to the post' do
      post_model.stub_chain(:comments, :new) { comment }
      comment.should_receive(:save) { true }

      post :create, post_id: post_model.id
      response.should redirect_to post_path(post_model)
      flash[:success].should == 'Comment successfully added.'
    end

    it 'should redirect if the comment cannot save' do
      post_model.stub_chain(:comments, :new) { comment }
      comment.should_receive(:save) { false }

      post :create, post_id: post_model.id
      response.should redirect_to post_path(post_model)
      flash[:error].should == 'We could not add your comment. Please make sure all required fields are filled-in.'
    end
  end
end
