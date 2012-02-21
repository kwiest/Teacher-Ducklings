require 'spec_helper'

describe UserSessionsController do
  let(:user)         { User.create(first_name: 'Kyle', last_name: 'Wiest', email: 'me@example.com', password: 'secret', password_confirmation: 'secret') }

  context 'already logged in' do
    before do
      subject.stub(:logged_in?) { true }
    end

    describe 'GET new' do
      it 'should redirect home' do
        get :new
        flash[:notice].should == 'You are already logged in.'
        response.should redirect_to root_path
      end
    end

    describe 'POST create' do
      it 'should redirect home' do
        post :create
        flash[:notice].should == 'You are already logged in.'
        response.should redirect_to root_path
      end
    end

    describe 'DELETE destroy' do
      it 'should destroy the UserSession' do
        UserSession.create(user)
        user_session = UserSession.find
        subject.stub(:current_user_session) { user_session }

        delete :destroy
        flash[:notice].should == 'Bye now. Come back soon!'
        response.should redirect_to root_path
      end
    end
  end

  context 'not logged in' do
    describe 'GET new' do
      it 'should assign a new user session' do
        get :new
        assigns(:user_session).kind_of?(UserSession).should be_true
        response.should render_template 'new'
      end
    end

    describe 'POST create' do
      context 'valid credentials passed' do
        it 'should redirect to the root_path if the user is not an admin' do
          u = User.create(first_name: 'Kyle', last_name: 'Wiest', email: 'you@example.com', password: 'secret', password_confirmation: 'secret')
          post :create, user_session: { email: 'you@example.com', password: 'secret' }
          flash[:success].should == 'Hi Kyle, so good to see you again!'
          response.should redirect_to root_path
        end

        it 'should redirect to the admin_root_path if the user is an admin' do
          u = User.create(first_name: 'Kyle', last_name: 'Wiest', email: 'us@example.com', password: 'secret', password_confirmation: 'secret', admin: true)
          post :create, user_session: { email: 'us@example.com', password: 'secret' }
          flash[:success].should == 'Hi Kyle, so good to see you again!'
          response.should redirect_to admin_root_path
        end
      end

      it 'should re-render the "new" template if invalid credentials are passed' do
        post :create, user_session: { email: 'me@example.com', password: 'not-secret' }
        response.should render_template 'new'
      end
    end

    describe 'DELETE destroy' do
      it 'should redirect to the root path' do
        subject.stub(:logged_in?) { false }
        delete :destroy
        flash[:notice].should == "Sorry, but you don't have access to that page."
        response.should redirect_to root_path
      end
    end
  end
end
