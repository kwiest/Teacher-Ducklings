require('spec_helper')

describe User do
  let(:user) { User.new }

  it 'should validate' do
    should validate_presence_of :first_name
    should validate_presence_of :last_name
    should validate_presence_of :email
  end

  it 'should check relationships' do
    should have_many(:videos)
    should have_many(:posts)
    should have_many(:comments)
    should have_many(:reviews)
    should have_many(:meetings)
  end

  it '#full_name' do
    user.first_name = 'Kyle'
    user.last_name = 'Wiest'
    user.full_name.should == 'Kyle Wiest'
  end

  it 'should be able to deliver password reset instructions' do
    mail = stub
    user.should_receive(:reset_perishable_token!)
    UserMailer.should_receive(:password_reset_instructions).with(user) { mail }
    mail.should_receive(:deliver)

    user.deliver_password_reset_instructions!
  end

  it 'should generate an OpenTok token from a session_id' do
    tok = stub
    OpenTok::OpenTokSDK.stub(:new) { tok }
    tok.should_receive(:generate_token)
    user.generate_tok_token('1234')
  end
end
