require('spec_helper')

describe Comment do
  it 'should validate' do
    should validate_presence_of(:post_id)
    should validate_presence_of(:user_id)
    should validate_presence_of(:body)
  end

  it 'should have relationships' do
    should belong_to(:post)
    should belong_to(:user)
  end
end
