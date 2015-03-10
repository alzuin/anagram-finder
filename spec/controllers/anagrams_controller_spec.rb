require 'rails_helper'

RSpec.describe AnagramsController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end
  end

  describe "GET create" do
    it "returns http success" do
      get :create
      expect(response).to be_success
    end
  end

  describe "GET show" do
    it "redirects to root" do
      get :show, id: 'stop'
      response.should redirect_to :root
    end

    it "responds with JSON" do
      $anagram.populate("test\nstop\npots\nopts\ntops\nbad\ndab")
      get :show, id: 'stop', format: :json
      parsed_body = JSON.parse(response.body)
      parsed_body["anagrams"].should == $anagram.words_hash[$anagram.create_index('stop')]
    end
  end

end
