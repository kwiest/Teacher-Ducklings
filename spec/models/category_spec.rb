require 'spec_helper'

describe Category do
  it 'should validate' do
    should validate_presence_of(:name)
  end

  it 'should have relationships' do
    should have_and_belong_to_many(:posts)
    should have_and_belong_to_many(:links)
  end

  it 'should be able to find a category by id and include its posts' do
    category = Category.create!(name: "Math")
    post = category.posts.create!(title: "Test post", body: "test post")
    link = category.links.create!(name: 'Test link')

    c = Category.find_with_posts_and_links(category.id)
    c.should == category
  end

  it 'should have a more pretty url param' do
    category = Category.create!(name: "Math")
    id = category.id
    category.to_param.should == "#{id}-math"
  end
end
