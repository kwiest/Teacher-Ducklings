require 'spec_helper'

describe 'Looking at a post page' do
  let(:post_model) { Factory(:post1) }
  let(:category)   { Factory(:category) }
  let(:admin)      { Factory(:admin) }
  let(:user)       { Factory(:user) }

  before :all do
    user.posts << post_model
  end

  it 'should display the title and body of the post' do
    visit post_path(post_model)
    page.has_selector?('h1#post-title', text: post_model.title).should be_true
    page.has_selector?('div#post-body', text: post_model.body).should be_true
  end

  it 'should have a list of comments' do
    visit post_path(post_model)
    page.has_selector?('#comments').should be_true
  end

  it 'should display only comments belonging to the post' do
    c1 = Comment.create(user: user, post: post_model, body: 'Comment 1')
    c2 = Comment.create(user: user, body: 'Comment 2')

    visit post_path(post_model)
    page.has_selector?('#comments .comment .comment-body', text: c1.body).should be_true
    page.has_selector?('#comments .comment .comment-body', text: c2.body).should_not be_true
  end

  context 'comments' do
    before do
      c1 = Comment.create(user: user, post: post_model, body: 'Comment 1')
    end

    context 'a user is logged in' do
      before do
        login user
        visit post_path(post_model)
      end

      it 'should display a new comment form' do
        page.has_selector?('h3', text: 'Leave a new comment').should be_true
        page.has_field?('comment_body').should be_true
      end
    
      it 'should create a new comment for the post' do
        fill_in('comment_body', with: 'What a great post!')
        click_button('comment_submit')
        page.has_selector?('#comments .comment .comment-body', text: 'What a great post!').should be_true
      end

      it 'should not display a link to delete a comment' do
        page.has_link?('Delete comment').should_not be_true
      end
    end

    context 'a user is not logged in' do
      it 'should not have a form if the user is not logged in' do
        logout
        visit post_path(post_model)
        page.has_selector?('h3', text: 'Leave a new comment').should_not be_true
        page.has_field?('comment_body').should_not be_true
      end

      it 'should not display a link to delete a comment' do
        page.has_link?('Delete comment').should_not be_true
      end
    end

    context 'an admin is logged in' do
      before do
        login admin
        visit post_path(post_model)
      end

      it 'should display a link to let an admin to delete comments' do
        page.has_link?('Delete comment').should be_true
      end

      it 'should allow an admin to delete comments' do
        pending
      end
    end
  end
end
