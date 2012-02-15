require('spec_helper')

describe Video do
  let(:user) { mock_model(User) }
  let(:video) { Video.new(user: user, video_file_name: "test.avi", title: "Test video") }

  it 'should validate' do
    should validate_presence_of(:user)
    should validate_presence_of(:title)
    should validate_presence_of(:video_file_name)
  end

  it 'should belong to a user and have many meetings and reviews' do
    should belong_to(:user)
    should have_many(:meetings)
    should have_many(:reviews)
  end

  it 'should find any videos uploaded within the past 7 days' do
    d1 = Date.today - 1.day
    d2 = Date.today - 8.days
    video2 = Video.create!(user: user, video_file_name: 'test.mov', title: "Test video #2")
    video.update_attributes(created_at: d1)
    video2.update_attributes(created_at: d2)

    videos = Video.find_recent_uploads
    videos.include?(video).should be_true
    videos.include?(video2).should be_false
  end

  it 'should give a #verbose_title' do
    video.verbose_title.should == "Test video - test.avi"
  end

  it 'should give an #encoded_file_name' do
    video.encoded_file_name.should == 'https://teacherducklings-test.s3.amazonaws.com/test.avi.mp4'
  end

  describe 'encoding videos' do
    let(:video_encoder) { stub }

    it 'should record an #ecoding_error!' do
      video.send(:encoding_error!, 'Forced error')
      video.error?.should be_true
      video.zencoder_error_message.should == 'Forced error'
    end

    context 'creating encoding jobs' do
      before do
        VideoEncoder.should_receive(:new) { video_encoder }
      end

      it 'should get a zencoder_job_id after calling #encode!' do
        video_encoder.stub(create_job: '123')
        video.encode!
        video.converting?.should be_true
        video.zencoder_job_id.should == '123'
      end

      it 'should record an error if #encode! fails' do
        video_encoder.stub(:create_job) { raise VideoEncoder::EncodingError }
        video.should_receive(:encoding_error!) { true }
        video.encode!
      end
    end

    context 'checking job status' do
      before do
        video.convert!
      end

      it 'should not check with VideoEncoder if the video is already complete' do
        video.complete!
        VideoEncoder.should_not_receive(:check_job_status)
        video.check_encoding_status
      end

      it 'should not check with VideoEncoder if the video is already in an error state' do
        video.error!
        VideoEncoder.should_not_receive(:check_job_status)
        video.check_encoding_status
      end

      it "update it's state if the job is 'complete'" do
        VideoEncoder.stub(:check_job_status) { { status: 'complete' } }
        video.check_encoding_status
        video.complete?.should be_true
      end

      it "should remain converting if the job isn't finished" do
        VideoEncoder.stub(:check_job_status) { { status: 'converting' } }
        video.check_encoding_status
        video.converting?.should be_true
      end

      it "update it's state if the job is 'error'" do
        VideoEncoder.stub(:check_job_status) { { status: 'error' } }
        video.check_encoding_status
        video.error?.should be_true
      end
    end
  end
end
