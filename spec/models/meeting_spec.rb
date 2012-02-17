require('spec_helper')

describe Meeting do
  let(:time)  { "12:00pm" }
  let(:user)  { mock_model(User) }
  let(:video) { mock_model(Video) }

  it 'should validate' do
    should validate_presence_of(:date)
    should validate_presence_of(:time)
    should validate_presence_of(:user)
    should validate_presence_of(:video)
  end

  it 'should belong to a moderator, a user and a video' do
    should belong_to(:moderator)
    should belong_to(:user)
    should belong_to(:video)
  end

  it 'should find all meetings that are within 7 days of today' do
    d1 = (Date.today + 7).to_s
    d2 = (Date.today + 1).to_s
    m1 = Meeting.create!(date: d1, time: time, user: user, video: video)
    m2 = Meeting.create!(date: d2, time: time, user: user, video: video)

    meetings = Meeting.find_upcoming_meetings
    meetings.include?(m1).should be_false
    meetings.include?(m2).should be_true
  end

  it 'should be expired if #date is less than today' do
    d = (Date.today - 1).to_s
    m1 = Meeting.new(date: d, time: time, user: user, video: video)
    m1.expired?.should be_true
  end

  it 'should tell you how many days from today the meeting is' do
    d = (Date.today + 2).to_s
    m = Meeting.new(date: d, time: time, user: user, video: video)
    m.days_from_today_to_meeting.should == 2
  end

  it 'should set the tok_session_id when given an ip address' do
    tok = stub
    session = stub(:session, session_id: '123')
    OpenTok::OpenTokSDK.should_receive(:new) { tok }
    tok.should_receive(:create_session) { session }
    d = (Date.today + 2).to_s
    m = Meeting.new(date: d, time: time, user: user, video: video)

    m.set_tok_session_id('127.0.0.0')
    m.tok_session_id.should == '123'
  end
end
