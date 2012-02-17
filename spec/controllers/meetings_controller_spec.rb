require 'spec_helper'

describe MeetingsController do
  let(:user) { mock_model(User) }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { user }
  end

  describe 'GET index' do
    it 'should assign all meetings belonging to the current_user' do
      meeting = stub
      Meeting.should_receive(:for_user).with(user) { [meeting] }

      get :index
      assigns(:meetings).should == [meeting]
    end
  end

  describe 'GET show' do
    let(:video)   { stub }
    let(:meeting) { mock_model(Meeting, video: video, tok_session_id: '123') }

    before do
      Meeting.stub(:find) { meeting }
    end

    it "shouldn't be viewed by the current user" do
      # User is not an admin
      # @meeting.user_to_meet_with_id != current_user
      meeting.stub(:user_to_meet_with_id) { '987' }
      user.stub(:admin) { false }

      get :show, id: meeting.id
      response.should redirect_to root_path
      flash[:error].should == "Sorry, but you're not scheduled to attend this meeting."
    end

    it 'should assign the meeting if the user is able to take part' do
      meeting.stub(:user_to_meet_with_id) { user.id }
      user.stub(:generate_tok_token)      { '123' }

      get :show, id: meeting.id
      response.should render_template('show')
      assigns(:meeting).should == meeting
    end

    it 'should redirect if the meeting cannot be found' do
      Meeting.stub(:find) { raise ActiveRecord::RecordNotFound }

      get :show, id: meeting.id
      response.should redirect_to(meetings_path)
      flash[:error].should == 'Sorry, but that meeting could not be found.'
    end
  end
end
