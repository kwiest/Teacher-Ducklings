require 'spec_helper'

describe 'Browsing the home page', type: :request do
  let(:user)  { Factory(:user) }
  let(:admin) { Factory(:admin) }

  it 'should have a list of categories' do
    visit root_path
    page.has_selector?('ul#categories').should be_true
  end

  it 'should have a list of the most recent posts' do
    visit root_path
    page.has_selector?('ul#recent-posts').should be_true
  end

  it 'should display a link to log in if no user is logged in' do
    logout
    visit root_path
    page.has_selector?(:xpath, './/a[@rel="log-in"]').should be_true
  end

  it "should display a the user's name and a link to log out if the user is logged in" do
    login user
    visit root_path
    page.has_selector?(:xpath, './/a[@rel="log-out"]').should be_true
    page.has_content?('Kyle Wiest').should be_true
  end
end
