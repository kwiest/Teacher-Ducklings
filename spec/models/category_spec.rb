require('spec_helper')

describe Category do
  it 'should validate' do
    should validate_presence_of(:name)
  end

  it 'should have relationships' do
    should have_and_belong_to_many(:posts)
    should have_and_belong_to_many(:links)
  end

  it 'should have a more pretty url param' do
    category = Category.create!(name: "Math")
    id = category.id
    category.to_param.should == "#{id}-math"
  end
end
