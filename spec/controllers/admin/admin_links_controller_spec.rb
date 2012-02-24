require 'spec_helper'

describe Admin::LinksController do
  let(:user) { stub(:user, admin: true) }
  let(:link) { mock_model(Link) }

  before do
    subject.stub(:logged_in?)   { true }
    subject.stub(:current_user) { user }
  end

  describe 'GET index' do
    it 'should assign all links' do
      Link.should_receive(:all) { [link] }
      get :index
      assigns(:links).should == [link]
    end
  end

  describe 'GET show' do
    it 'should assign the link by :id' do
      Link.should_receive(:find).with(link.id.to_s) { link }
      get :show, id: link.id
      assigns(:link).should == link
    end

    it 'should redirect if the link cannot be found' do
      Link.should_receive(:find).with(link.id.to_s) { raise ActiveRecord::RecordNotFound }
      get :show, id: link.id
      flash[:error].should == 'Sorry, but we could not find that link.'
      response.should redirect_to admin_links_path
    end
  end

  describe 'GET new' do
    it 'should assign a new Link' do
      Link.should_receive(:new) { link }
      get :new
      assigns(:link).should == link
      response.should render_template 'new'
    end
  end

  describe 'GET edit' do
    it 'should assign the link by :id' do
      Link.should_receive(:find).with(link.id.to_s) { link }
      get :edit, id: link.id
      assigns(:link).should == link
      response.should render_template 'edit'
    end

    it 'should redirect if the link cannot be found' do
      Link.should_receive(:find).with(link.id.to_s) { raise ActiveRecord::RecordNotFound }
      get :edit, id: link.id
      flash[:error].should == 'Sorry, but we could not find that link.'
      response.should redirect_to admin_links_path
    end
  end

  describe 'POST create' do
    it 'should create a new link and redirect if valid' do
      Link.should_receive(:new) { link }
      link.should_receive(:save) { true }
      post :create
      flash[:success].should == 'Link was successfully created.'
      response.should redirect_to admin_links_path
    end

    it 'should re-render the "new" template if it does not save' do
      Link.should_receive(:new) { link }
      link.should_receive(:save) { false }
      post :create
      assigns(:link).should == link
      response.should render_template 'new'
    end
  end

  describe 'PUT update' do
    it 'should update the attributes of the link by :id' do
      Link.should_receive(:find).with(link.id.to_s) { link }
      link.should_receive(:update_attributes) { true }
      put :update, id: link.id
      flash[:success].should == 'Link was successfully updated.'
      response.should redirect_to admin_links_path
    end

    it 'should re-render the edit template if the link does not save' do
      Link.should_receive(:find).with(link.id.to_s) { link }
      link.should_receive(:update_attributes) { false }
      put :update, id: link.id
      assigns(:link).should == link
      response.should render_template 'edit'
    end

    it 'should redirect if the link cannot be found' do
      Link.should_receive(:find).with(link.id.to_s) { raise ActiveRecord::RecordNotFound }
      put :update, id: link.id
      flash[:error].should == 'Sorry, but we could not find that link.'
      response.should redirect_to admin_links_path
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy the link by :id' do
      Link.should_receive(:find).with(link.id.to_s) { link }
      link.should_receive(:destroy) { true }
      delete :destroy, id: link.id
      flash[:notice].should == 'Link was successfully deleted.'
      response.should redirect_to admin_links_path
    end

    it 'should redirect if the link cannot be found' do
      Link.should_receive(:find).with(link.id.to_s) { raise ActiveRecord::RecordNotFound }
      delete :destroy, id: link.id
      flash[:error].should == 'Sorry, but we could not find that link.'
      response.should redirect_to admin_links_path
    end
  end
end
