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

  describe "POST create" do
    it "returns http success" do
      post :create
      expect(response).to be_success
    end
    it "can upload the dictionary" do
      @file = fixture_file_upload('files/dictionary.txt', 'text/plain')
      post :create, anagram: {file: @file}
      $anagram.words_hash.count.should > 0
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
