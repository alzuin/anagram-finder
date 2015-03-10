require 'rails_helper'

RSpec.describe Anagram, :type => :model do
  it 'populate the hash with empty content' do
    $anagram.populate('')
    $anagram.words_hash.count.should == 0
  end
  it 'populate the hash' do
    $anagram.populate("test\nstop\npots\nopts\ntops\nbad\ndab")
    $anagram.words_hash.count.should > 0
  end
  it 'populate the hash with a file with crlf' do
    $anagram.populate("test\n\rstop\n\rpots\n\ropts\n\rtops\n\rbad\n\rdab")
    $anagram.words_hash.count.should > 0
  end
  it 'detect the correct number anagram' do
    $anagram.populate("test\nstop\npots\nopts\ntops\nbad\ndab")
    $anagram.words_hash[$anagram.create_index('stop')].count.should == 4
  end
end
