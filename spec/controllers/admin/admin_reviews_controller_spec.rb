require 'spec_helper'

describe Admin::ReviewsController do
  let(:video)  { mock_model(Video) }
  let(:review) { mock_model(Review) }
  let(:user)   { mock_model(User, admin: true) }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { user }
  end

  context 'If the parent video is not found' do
    before do
      Video.should_receive(:find).with(video.id) { raise ActiveRecord::RecordNotFound }
    end

    describe 'GET show' do
      it 'should redirect if the video cannot be found' do
        get :show, video_id: video.id, id: review.id
        flash[:notice].should == 'Sorry, but we cannot find that video.'
        response.should redirect_to admin_videos_path
      end
    end

    describe 'GET new' do
      it 'should redirect if the video cannot be found' do
        get :new, video_id: video.id
        flash[:notice].should == 'Sorry, but we cannot find that video.'
        response.should redirect_to admin_videos_path
      end
    end

    describe 'GET edit' do
      it 'should redirect if the video cannot be found' do
        get :edit, video_id: video.id, id: review.id
        flash[:notice].should == 'Sorry, but we cannot find that video.'
        response.should redirect_to admin_videos_path
      end
    end

    describe 'POST create' do
      it 'should redirect if the video cannot be found' do
        post :create, video_id: video.id
        flash[:notice].should == 'Sorry, but we cannot find that video.'
        response.should redirect_to admin_videos_path
      end
    end

    describe 'PUT update' do
      it 'should redirect if the video cannot be found' do
        put :update, video_id: video.id, id: review.id
        flash[:notice].should == 'Sorry, but we cannot find that video.'
        response.should redirect_to admin_videos_path
      end
    end

    describe 'DELETE destroy' do
      it 'should redirect if the video cannot be found' do
        delete :destroy, video_id: video.id, id: review.id
        flash[:notice].should == 'Sorry, but we cannot find that video.'
        response.should redirect_to admin_videos_path
      end
    end
  end

  context 'If the parent video is found' do
    before do
      Video.should_receive(:find).with(video.id) { video }
    end

    describe 'GET show' do
      it 'should assign the review by :id' do
        video.stub_chain(:reviews, :find) { review }

        get :show, video_id: video.id, id: review.id
        assigns(:review).should == review
      end

      it 'should redirect if the review cannot be found' do
        video.stub_chain(:reviews, :find) { raise ActiveRecord::RecordNotFound }

        get :show, video_id: video.id, id: review.id
        flash[:notice].should == 'Sorry, but we cannot find that review.'
        response.should redirect_to admin_video_path(video)
      end
    end

    describe 'GET new' do
      it 'should assign a new review' do
        video.stub_chain(:reviews, :new) { review }
        get :new, video_id: video.id
        assigns(:review) { review }
      end
    end

    describe 'GET edit' do
      it 'should assign the review by :id' do
        video.stub_chain(:reviews, :find) { review }
        get :edit, video_id: video.id, id: review.id
        assigns(:review).should == review
      end

      it 'should redirect if the review cannot be found' do
        video.stub_chain(:reviews, :find) { raise ActiveRecord::RecordNotFound }

        get :edit, video_id: video.id, id: review.id
        flash[:notice].should == 'Sorry, but we cannot find that review.'
        response.should redirect_to admin_video_path(video)
      end
    end

    describe 'POST create' do
      it 'should create a new review belonging to the current_user and redirect if valid' do
        video.stub_chain(:reviews, :new) { review }
        review.should_receive(:save) { true }

        post :create, video_id: video.id, review: { description: 'Good job!' }
        assigns(:review_params).should == { 'description' => 'Good job!', 'user_id' => user.id }
        flash[:success].should == 'Your review was successfully recorded.'
        response.should redirect_to admin_video_path(video)
      end

      it 'should re-render the "new" template if the review cannot save' do
        video.stub_chain(:reviews, :new) { review }
        review.should_receive(:save) { false }

        post :create, video_id: video.id, review: { description: 'Good job!' }
        assigns(:review).should == review
        response.should render_template 'new'
      end
    end

    describe 'PUT update' do
      it 'should update the attributes of the review and redirect' do
        video.stub_chain(:reviews, :find) { review }
        review.should_receive(:update_attributes) { true }
        
        put :update, video_id: video.id, id: review.id
        flash[:success].should == 'Your review was successfully updated.'
        response.should redirect_to admin_video_path(video)
      end

      it 'should re-render the "edit" template if the review cannnot be updated' do
        video.stub_chain(:reviews, :find) { review }
        review.should_receive(:update_attributes) { false }

        put :update, video_id: video.id, id: review.id
        assigns(:review).should == review
        response.should render_template 'edit'
      end

      it 'should redirect if the review cannot be found' do
        video.stub_chain(:reviews, :find) { raise ActiveRecord::RecordNotFound }

        put :update, video_id: video.id, id: review.id
        flash[:notice].should == 'Sorry, but we cannot find that review.'
        response.should redirect_to admin_video_path(video)
      end
    end

    describe 'DELETE destroy' do
      it 'should delete the review by :id' do
        video.stub_chain(:reviews, :find) { review }
        review.should_receive(:destroy) { true }

        delete :destroy, video_id: video.id, id: review.id
        flash[:notice].should == 'Your review was successfully deleted.'
        response.should redirect_to admin_video_path(video)
      end

      it 'should redirect if the review cannot be found' do
        video.stub_chain(:reviews, :find) { raise ActiveRecord::RecordNotFound }

        delete :destroy, video_id: video.id, id: review.id
        flash[:notice].should == 'Sorry, but we cannot find that review.'
        response.should redirect_to admin_video_path(video)
      end
    end
  end
end
