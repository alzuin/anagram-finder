# Anagram class
# It is a basic model, not an active model for choice.
# To improve the speed, I decided to store all the words list in RAM, without the use of an external database
# In fact, the bigger words database that I found on the web, is almost 3.5 MB, so can be loaded on RAM on the
# most part of new PC.
class Anagram
  # Constant used only in method 3
  CHAR_MAP ={ "a" => 2, "b" => 3, "c" => 5, "d" => 7, "e" => 11, "f" => 13, "g" =>17, "h" =>19, "i" => 23, "j" => 29, "k" => 31, "l" => 37, "m" => 41, "n" =>43, "o" =>47, "p" => 53, "q" =>59, "r" => 61, "s" => 67, "t" => 71, "u" => 73, "v" => 79, "w" => 83, "x" => 89, "y" => 97, "z" => 101, "'" => 103 }

  # We define some class attributes: we use attr_accessor instead of a manual definition because in recent version
  # the speed is almost identical
  # * file: is the uploaded file
  # * time_file: is the time for reading and processing the file
  # * word_hash: is the hash where we store the anagrams (after the upload)
  # * messages: is the lines of message inside the text area
  attr_accessor :file, :time_file, :words_hash

  # We initialize word_hash as an Hash and messages as a string
  def initialize
    self.words_hash = {}
  end

  # Function to populate the hash with all the anagrams.
  # * words is a string of words separated by newline (\n)
  def populate(words)
    # Create an array of words and normailze it: we delete all cr chars (\r) and put all letters downcase
    words = words.downcase.delete("\r").split("\n")
    # The anagram words contain the same letters, so we can create an hash where the key is a common index,
    # and the value is an array of words with the same key
    self.words_hash = words.each_with_object(Hash.new []) do |word,hash|
      hash[create_index(word)] += [word]
    end
  end

  # Function to create the hash index
  # we use one of the privates function below to create an index for every group of anagram
  # I tried more than one, just to find the better option
  def create_index(word)
    create_index1(word)
  end

  private

  # Method 1: we use internal chars function added in ruby 1.9.3 to split the word in an array of letters, sort the letters
  # with sort! and re-join the letters with join to have the ordered word
  def create_index1(word)
    word.chars.sort!.join
  end

  # Method 2: we convert every char of the word in a prime number in order to create a numeric signature
  def create_index2(word)
    word.each_char.map {|c| CHAR_MAP[c.downcase]}.reduce(:*)
  end

  # Method 3; like te first, but we use original 1.8 split function instead of chars
  def create_index3(word)
    word.split('').sort!.join
  end
end
