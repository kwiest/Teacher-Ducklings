require 'spec_helper'

describe PasswordResetsController do
  context 'the user is logged in' do
    before do
      subject.stub(:logged_in?) { true }
    end

    describe 'GET new' do
      it 'should redirect' do
        get :new
        flash[:notice].should == "Sorry, but you can't reset your password if you're already logged in."
        response.should redirect_to root_path
      end
    end

    describe 'GET edit' do
      it 'should redirect' do
        get :edit, id: 'gibberish'
        flash[:notice].should == "Sorry, but you can't reset your password if you're already logged in."
        response.should redirect_to root_path
      end
    end

    describe 'POST create' do
      it 'should redirect' do
        post :create
        flash[:notice].should == "Sorry, but you can't reset your password if you're already logged in."
        response.should redirect_to root_path
      end
    end

    describe 'PUT update' do
      it 'should redirect' do
        put :update, id: 'gibberish'
        flash[:notice].should == "Sorry, but you can't reset your password if you're already logged in."
        response.should redirect_to root_path
      end
    end
  end

  context 'the user is not logged in' do
    let(:user) { stub }

    before do
      subject.stub(:logged_in?) { false }
    end

    describe 'GET new' do
      it 'should render the "new" template' do
        get :new
        response.should render_template 'new'
      end
    end

    describe 'GET edit' do
      it 'should assign the user by perishable_token' do
        User.should_receive(:find_using_perishable_token).with('gibberish') { user }

        get :edit, id: 'gibberish'
        assigns(:user).should == user
      end

      it 'should re-render the "new" template if the user cannot be found' do
        User.should_receive(:find_using_perishable_token).with('gibberish') { nil }

        get :edit, id: 'gibberish'
        flash[:error].should == "We're sorry, but we could not locate your account. Try pasting the URL from your email into your browser."
        response.should render_template 'new'
      end
    end

    describe 'POST create' do
      it 'should deliver instructions and reset if the user is found' do
        User.should_receive(:find_by_email).with('me@example.com') { user }
        user.should_receive(:deliver_password_reset_instructions!) { true }

        post :create, email: 'me@example.com'
        flash[:success].should == 'Instructions on how to reset your password have been emailed to you.'
        response.should redirect_to root_path
      end

      it 'should re-render the "new" template if the user cannot be found' do
        User.should_receive(:find_by_email).with('me@example.com') { nil }
        user.should_not_receive(:deliver_password_reset_instructions!) { true }

        post :create, email: 'me@example.com'
        response.should render_template 'new'
      end
    end

    describe 'PUT update' do
      it 'should redirect if the user is found and updating succeeds' do
        User.should_receive(:find_using_perishable_token).with('gibberish') { user }
        user.should_receive(:update_attributes) { true }

        put :update, id: 'gibberish'
        flash[:success].should == 'Your password has been successfully updated.'
        response.should redirect_to root_path
      end

      it 'should re-render the "edit" template if the user is found but updating fails' do
        User.should_receive(:find_using_perishable_token).with('gibberish') { user }
        user.should_receive(:update_attributes) { false }

        put :update, id: 'gibberish'
        flash[:notice].should == 'Sorry, but your password was not updated. Please try again.'
        response.should render_template 'edit'
      end

      it 'should re-render the "new" template if the user cannot be found' do
        User.should_receive(:find_using_perishable_token).with('gibberish') { nil }

        put :update, id: 'gibberish'
        flash[:error].should == "We're sorry, but we could not locate your account. Try pasting the URL from your email into your browser."
        response.should render_template 'new'
      end
    end
  end
end
