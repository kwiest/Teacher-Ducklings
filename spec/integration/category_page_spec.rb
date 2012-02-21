require 'spec_helper'

describe 'Looking at the category pages' do
  let(:category) { Factory(:category) }
  let(:post1)    { Factory(:post1) }
  let(:post2)    { Factory(:post2) }
  let(:link)     { Factory(:link) }

  it 'should display the name of the category' do
    visit category_path(category)
    page.has_selector?('h1', text: category.name).should be_true
  end

  it 'should display a list of posts' do
    visit category_path(category)
    page.has_selector?('#posts').should be_true
  end

  it 'should only include posts belonging to the category' do
    category.posts << post1
    visit category_path(category)
    
    page.has_content?(post1.title).should be_true
    page.has_content?(post2.title).should be_false
  end

  it 'should display a list of links belonging to the category' do
    visit category_path(category)
    page.has_selector?('ul#links').should be_true
  end

  it 'should only include the links belonging to the category' do
    link2 = Link.create(name: 'Tool2', description: 'Another link')
    category.links << link
    visit category_path(category)

    page.has_content?(link.description).should be_true
    page.has_content?(link2.description).should be_false
  end
end
