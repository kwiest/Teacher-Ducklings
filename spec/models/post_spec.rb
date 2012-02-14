require('spec_helper')

describe Post do
  it 'should validate' do
    should validate_presence_of(:title)
    should validate_presence_of(:body)
  end

  it 'should have relationships with users, comments, and categories' do
    should belong_to(:user)
    should have_many(:comments)
    should have_and_belong_to_many(:categories)
  end

  it 'should have a pretty #to_param for urls' do
    p = Post.create!(title: 'Hello', body: 'World!')
    id = p.id
    p.to_param.should == "#{id}-hello"
  end
end
