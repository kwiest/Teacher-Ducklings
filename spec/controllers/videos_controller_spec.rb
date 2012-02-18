require 'spec_helper'

describe VideosController do
  let(:video) { mock_model(Video) }
  let(:user)  { stub }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { user }
  end

  describe 'GET index' do
    it 'should assign the videos belonging to the current_user' do
      user.stub(:videos) { [video] }
      get :index
      assigns(:videos).should == [video]
    end
  end

  describe 'GET show' do
    it 'should assign the video' do
      user.stub_chain(:videos, :find) { video }
      video.stub(:check_encoding_status) { 'complete' }

      get :show, id: video.id
      assigns(:video).should == video
    end

    it 'should check the zencoder status' do
      user.stub_chain(:videos, :find) { video }
      video.should_receive(:check_encoding_status) { 'complete' }
      get :show, id: video.id
    end

    it 'should redirect if the video cannot be found' do
      user.stub_chain(:videos, :find) { raise ActiveRecord::RecordNotFound }
      get :show, id: video.id
      response.should redirect_to videos_path
      flash[:error].should == "We're sorry, but the video you're looking for cannot be found."
    end
  end
end
