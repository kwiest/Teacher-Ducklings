require('spec_helper')

describe Link do
  it 'should validate' do
    should validate_presence_of(:name)
  end

  it 'should have and belong to many categories' do
    should have_and_belong_to_many(:categories)
  end
end
