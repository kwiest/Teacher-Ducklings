require 'spec_helper'

describe Admin::VideosController do
  let(:video) { mock_model(Video) }
  let(:user)  { stub(:user, admin: true) }

  before do
    subject.stub(:logged_in?)             { true }
    subject.stub(:current_user)           { user }
    subject.stub(:find_recent_videos)     { true }
    subject.stub(:find_upcoming_meetings) { true }
  end

  describe 'GET index' do
    it 'should assign all videos' do
      Video.should_receive(:all) { [video] }
      get :index
      assigns(:videos).should == [video]
    end
  end

  describe 'GET show' do
    it 'should assign the video by :id and check its encoding status' do
      Video.should_receive(:find).with(video.id.to_s) { video }
      video.should_receive(:check_encoding_status) { 'converting' }

      get :show, id: video.id
      assigns(:video).should == video
    end

    it 'should redirect if the video cannot be found' do
      Video.should_receive(:find).with(video.id.to_s) { raise ActiveRecord::RecordNotFound }

      get :show, id: video.id
      flash[:notice].should == 'Sorry, but that video could not be found.'
      response.should redirect_to admin_videos_path
    end
  end

  describe 'GET new' do
    it 'should assign a new video belonging to the current_user' do
      user.stub_chain(:videos, :new) { video }
      get :new
      assigns(:video).should == video
    end
  end

  describe 'POST create' do
    before do
      user.stub_chain(:videos, :new) { video }
    end

    it 'should create a new video belonging to the current_user and redirect if it can save' do
      video.should_receive(:save) { true }
      video.should_receive(:encode!) { true }

      post :create
      flash[:success].should == 'Video successfully created.'
      response.should redirect_to admin_videos_path
    end

    it 'should re-render the "new" template if the video cannot save' do
      video.should_receive(:save) { false }
      video.should_not_receive(:encode!)

      post :create
      assigns(:video).should == video
      response.should render_template 'new'
    end
  end

  describe 'DELETE destroy' do
    it 'should delete files on s3, then delete the video, then redirect' do
      Video.should_receive(:find).with(video.id.to_s) { video }
      video.should_receive(:delete_files_from_s3) { true }
      video.should_receive(:destroy) { true }

      delete :destroy, id: video.id
      flash[:notice].should == 'Video successfully deleted.'
      response.should redirect_to admin_videos_path
    end

    it 'should redirect if the video cannot be found' do
      Video.should_receive(:find).with(video.id.to_s) { raise ActiveRecord::RecordNotFound }

      delete :destroy, id: video.id
      flash[:notice].should == 'Sorry, but that video could not be found.'
      response.should redirect_to admin_videos_path
    end
  end
end
