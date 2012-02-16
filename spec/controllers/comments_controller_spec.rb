require 'spec_helper'

describe CommentsController do
  describe 'POST create' do
    let(:cpost)   { mock_model(Post) }
    let(:comment) { stub }

    before do
      Post.stub(:find) { cpost }
    end

    it 'should save a comment and redirect to the post' do
      cpost.stub_chain(:comments, :new) { comment }
      comment.should_receive(:save) { true }

      post :create, post_id: cpost.id
      response.should redirect_to post_path(cpost)
      flash[:success].should == 'Comment successfully added.'
    end

    it 'should redirect if the comment cannot save' do
      cpost.stub_chain(:comments, :new) { comment }
      comment.should_receive(:save) { false }

      post :create, post_id: cpost.id
      response.should redirect_to post_path(cpost)
      flash[:error].should == 'We could not add your comment. Please make sure all required fields are filled-in.'
    end
  end
end
