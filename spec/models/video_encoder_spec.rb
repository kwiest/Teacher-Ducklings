require_relative '../../app/models/video_encoder'
require 'fake_zencoder'

describe VideoEncoder do
  let(:success)    { 1 }
  let(:failure)    { 2 }
  let(:processing) { 3} 
  let(:exception)  { 'error' }

  context 'Checking job status' do
    let(:video_encoder) { VideoEncoder.new(video) }

    it "should be 'complete'" do
      result = VideoEncoder.check_job_status success
      result[:status].should == 'complete'
    end

    it "should be 'converting'" do
      result = VideoEncoder.check_job_status processing
      result[:status].should == 'converting'
    end

    it "should be 'error'" do
      result = VideoEncoder.check_job_status failure
      result[:status].should == 'error'
      result[:message].should == 'Fake Zencoder forced failure'
    end

    it 'should swallow a Zencoder::HTTPError and build a result' do
      result = VideoEncoder.check_job_status exception
      result[:status].should == 'error'
      result[:message].should == 'Fake Zencoder forced Exception'
    end
  end

  context 'Creating jobs' do
    let(:video)         { stub(video_file_name: 'test.avi') }
    let(:video_encoder) { VideoEncoder.new(video) }

    it 'should create a new job and return a job_id' do
      video_encoder.stub(job_recipe: success)
      job_id = video_encoder.create_job
      job_id.should == 1
    end

    it 'should raise an exception when a job fails' do
      video_encoder.stub(job_recipe: failure)
      expect { video_encoder.create_job }.should raise_error(VideoEncoder::EncodingError)
    end

    it 'should swallow a Zencoder::HTTPError and wrap it in a VideoEncoder::HTTPError' do
      video_encoder.stub(job_recipe: exception)
      expect { video_encoder.create_job }.should raise_error(VideoEncoder::EncodingError)
    end
  end
end
