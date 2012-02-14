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
end
