class AnagramsController < ApplicationController
  require 'benchmark'

  # The index page: to improve the readability, we check the dimension of the measured time
  # and convert it in milliseconds if is < 1
  def index
    unless $anagram.time_file.nil?
      if $anagram.time_file.real < 1
        @time = ($anagram.time_file.real*1000).round(3).to_s + ' ms'
      else
        @time = ($anagram.time_file.real).round(2).to_s + ' sec'
      end
    end

    @messages = session[:tmp_messages]
    session[:tmp_message] = nil
  end

  # Here we handle the upload and process of the file
  def create
    # if the user press the upload button without choosing the file
    if params[:anagram].nil? or params[:anagram][:file].nil?
      flash.now[:error] = 'Please, choose a file'
      render :index
    else
      $anagram.time_file = Benchmark.measure do
        # We read the file in ram
        $anagram.file = params[:anagram][:file]
        # We populate the hash
        $anagram.populate($anagram.file.read)
        # Last we reset the $anagram.file global variable only with the filename to free some RAM
        $anagram.file = $anagram.file.original_filename
      end
      redirect_to root_url
    end
  end

  # Word search
  def show
    # First we downcase the word and initialize the anagrams array
    if params[:anagram].nil?
      word = params[:id].downcase
      old_messages = ''
    else
      word = params[:anagram][:word].downcase
      old_messages = params[:anagram][:messages]
    end

    anagrams =[]
    # Get the array of words from the hash
    total = Benchmark.measure do
      anagrams = $anagram.words_hash[$anagram.create_index(word)]
    end
    # Respond to html with a redirect and json
    respond_to do |format|
      format.html do
        # Add the message for the text area and store it in a temporary session
        session[:tmp_messages] = add_message(anagrams,word,total,old_messages)
        redirect_to root_url
      end
      format.json do
        render json: {word: word, anagrams: anagrams, total: total}
      end
    end
  end

  private

  # Function to add the message to the text area
  # I prefer to add the last message on top and not at the end
  # because it's easy to read it
  def add_message(anagrams,word,total,messages)
    # First: date and time for the search
    new_messages = "#{Time.now}\n"
    if anagrams.nil? or anagrams.count == 0
      # No anagram found
      new_messages += "0 anagrams found for #{word}\n\n"
    else
      # we have one or more anagrams
      new_messages +="#{anagrams.count} anagrams found for '#{word}' in #{(total.real*1000).round(3)} ms\n"
      new_messages += "> #{anagrams.join(', ')}\n\n"
    end
    # Add the message at the top
    new_messages + messages.to_s
  end
end
