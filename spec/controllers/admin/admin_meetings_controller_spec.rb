require 'spec_helper'

describe Admin::MeetingsController do
  let(:meeting) { mock_model(Meeting) }
  let(:user)    { stub(:user, admin: true) }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { user }
  end

  describe 'GET index' do
    it 'should assign all meetings' do
      Meeting.should_receive(:all) { [meeting] }
      get :index
      assigns(:meetings).should == [meeting]
    end

    it 'should parse params[:month] for calendar' do
      date = Date.parse('2012-03-01')
      get :index, month: date.to_s
      assigns(:date).should == date
    end

    it 'should set today as the default if no date is passed for calendar' do
      date = Date.today
      get :index
      assigns(:date).should == date
    end
  end

  describe 'GET new' do
    it 'should assign a new meeting' do
      Meeting.should_receive(:new) { meeting }
      get :new
      assigns(:meeting).should == meeting
    end
  end

  describe 'GET edit' do
    it 'should assign the meeting by :id' do
      Meeting.should_receive(:find).with(meeting.id) { meeting }
      get :edit, id: meeting.id
      assigns(:meeting).should == meeting
    end

    it 'should redirect if the meeting cannot be found' do
      Meeting.should_receive(:find).with(meeting.id) { raise ActiveRecord::RecordNotFound }
      get :edit, id: meeting.id
      flash[:error].should == 'Sorry, but that meeting could not be found.'
      response.should redirect_to admin_meetings_path
    end
  end

  describe 'POST create' do
    before do
      Meeting.should_receive(:new) { meeting }
      meeting.should_receive(:set_tok_session_id) { true }
    end

    it 'should create a new meeting, set the tok_session_id and redirect' do
      meeting.should_receive(:save) { true }
      post :create
      flash[:success].should == 'Meeting was successfully scheduled.'
      response.should redirect_to admin_meetings_path
    end

    it 'should re-render the "new" template if it cannot be saved' do
      meeting.should_receive(:save) { false }
      post :create
      response.should render_template 'new'
    end
  end

  describe 'PUT update' do
    it "should update the meeting's attributes by :id" do
      Meeting.should_receive(:find).with(meeting.id) { meeting }
      meeting.should_receive(:set_tok_session_id) { true }
      meeting.should_receive(:update_attributes) { true }

      put :update, id: meeting.id
      flash[:success].should == 'Meeting was successfully updated.'
      response.should redirect_to admin_meetings_path
    end

    it 'should re-render the "edit" template if it is not valid' do
      Meeting.should_receive(:find).with(meeting.id) { meeting }
      meeting.should_receive(:set_tok_session_id) { true }
      meeting.should_receive(:update_attributes) { false }

      put :update, id: meeting.id
      response.should render_template 'edit'
    end

    it 'should redirect if the meeting cannot be found' do
      Meeting.should_receive(:find).with(meeting.id) { raise ActiveRecord::RecordNotFound }
      put :update, id: meeting.id
      flash[:error].should == 'Sorry, but that meeting could not be found.'
      response.should redirect_to admin_meetings_path
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the meeting by :id' do
      Meeting.should_receive(:find).with(meeting.id) { meeting }
      meeting.should_receive(:destroy) { true }

      delete :destroy, id: meeting.id
      flash[:notice].should == 'Meeting was successfully deleted.'
      response.should redirect_to admin_meetings_path
    end

    it 'should redirect if the meeting cannot be found' do
      Meeting.should_receive(:find).with(meeting.id) { raise ActiveRecord::RecordNotFound }
      delete :destroy, id: meeting.id
      flash[:error].should == 'Sorry, but that meeting could not be found.'
      response.should redirect_to admin_meetings_path
    end
  end
end
