require 'spec_helper'

describe UsersController do
  let(:user) { mock_model(User) }

  context 'without logging in' do
    before do
      subject.stub(:logged_in?) { false }
    end

    describe 'GET show' do
      it 'should redirect' do
        get :show, id: user.id
        flash[:notice].should == "Sorry, but you don't have access to that page."
        response.should redirect_to root_path
      end
    end

    describe 'GET edit' do
      it 'should redirect' do
        get :edit, id: user.id
        flash[:notice].should == "Sorry, but you don't have access to that page."
        response.should redirect_to root_path
      end
    end

    describe 'PUT update' do
      it 'should redirect' do
        put :update, id: user.id
        flash[:notice].should == "Sorry, but you don't have access to that page."
        response.should redirect_to root_path
      end
    end
  end

  context 'with logging in' do
    before do
      subject.stub(:logged_in?)   { true }
      subject.stub(:current_user) { user }
    end

    describe 'GET show' do
      it 'should assign the current user' do
        get :show, id: user.id
        assigns(:user).should == user
      end
    end

    describe 'GET edit' do
      it 'should assign the current user' do
        get :edit, id: user.id
        assigns(:user).should == user
      end
    end

    describe 'PUT update' do
      it 'should redirect if the user is valid' do
        user.should_receive(:update_attributes) { true }

        put :update, id: user.id
        flash[:success].should == 'User profile successfully updated.'
        response.should redirect_to user_path(user)
      end

      it 'should re-render the "edit" template if it is not valid' do
        user.should_receive(:update_attributes) { false }

        put :update, id: user.id
        assigns(:user).should == user
        response.should render_template 'edit'
      end
    end
  end
end
