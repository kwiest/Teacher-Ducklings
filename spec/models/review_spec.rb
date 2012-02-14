require('spec_helper')

describe Review do
  it 'should validate' do
    should validate_presence_of(:description)
  end

  it 'should belong to a user and a video' do
    should belong_to(:video)
    should belong_to(:user)
  end
end
