require 'rails_helper'

RSpec.describe "anagrams/index.html.erb", :type => :view do
  it 'display a title in a h1 tag' do
    render
    rendered.should match(/<h1>Anagram Finder/)
  end
end
