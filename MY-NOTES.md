# Anagram finder
## Alberto Zuin

The basic idea behind my application is to create an hash of words with a common key between all words that are anagrams.
In this way, the bigger part of the time is spent one time during the dictionary file upload (and parsing), but the search phase will run fast.
Using this approach, also, the persistent database is not really needed: I found online a dictionary of 320,000 words, it is a file of about 3.5MB, so it is possible to store it in RAM on a decent computer without any big problem.
Is for that reason that the model Anagram is not an ActiveRecord model and I choose to initialize a global variable at startup (/config/initializers/anagram.rb), so the dictionary is shared between all visitors in different browsers.

The most slow thing of the algorithm, that influences both the file load and the search, is the way to create the key for the hash. I tried three different approaches to find the best option (all three are on app/model/anagram.rb file).

1. create_index1: this is the most efficient. We split the word in an array of letters using "chars" method introduced with Ruby 1.9.3. After the split, we used the sort! method to sort the letters and re-joined them in a word with join. With this methods, for example, the two words stop and post have the same key "opst"
2. create_index2: we tried a tricky approach converting every letter in a prime number and get the key multiplying all numbers. With this methods, for example, the two words stop and post has the same key "11849687". I was pretty confident that this way would be faster than the first, but at the end was 2 times slower.
3. create_index3: this is the same approach of point 1, but without using chars method. Instead, here we used split('') like we did on ruby 1.8

Using the big dictionary file of 330K words, method 1 reads the file in 2 seconds, method 2 in 4 seconds, method 3 in 6 seconds on a MacBook Air.

Obviously in "real life", I would not let the three methods in the code, but I think here is useful to better understand what I did.

Coming to controller, the show action redirects to the home page and updates the text_field as you request, but also implements a JSON output that is useful also for check purposes (ex. http://127.0.0.1:3000/anagrams/stop.json).
To update the text field simply we use a private controller function that get the actual content of the text_field and add the new message on top: I prefer to put on top so you don't have to scroll down the text field to read the new response.
Writing the code to update the text field inside the controller or inside the model is a delicate choice: the BP of Ruby on Rails suggests to have fat model and small controller, but in this case this function doesn't have anything to do with the model so I chose to let it in the controller.
Last, about the way used to pass the message for text area from the show action to index: we could pass it as parameter but the message tends to become pretty big and many system administrator prefer to limit the size of get parameters at webserver level (Apache/Nginx).
For this reason I chose to create a temporary session in show action and delete it in index.

About the only one view: as I said to Ed, I'm not a good graphic designer, so I included a third party css (skeleton) in assets, just to have a decent view. I know I don't have to include external gems and I imagine the most important thing of the exercise is not the view... so I think this small digression can be accepted by you.

About the test: I'm pretty confident that I made a good work for model and controller. Sincerely, is possible to have better test for the view using Capybara gem, but without it the possible tests are very basic.
Also, in my case, the Factory Girl gem is not pretty useful and I populated the hash passing a string of words by hand. On the other hand, a gem like Faker can be useful to create a dictionary without inserting the words by hand.

Going in production: really I don't think that with this code we are very far from a production level code. I tried to load a file with 1,200,000 words (little bigger than your hypothesis), the file is 14 MB big and the load time on my PC is under 10 seconds.
The speed of the queries are also very impressive (0.020 ms on my PC regardless of the size of the word and the amount of anagrams found) so I think we are very far from the need to scale up our system in horizontal.
In any case, if we want to do that for exercise, the only thing we need is to share the hash between our pool of application servers, and also share the session with the message for the text area. All the two things can be achieved without any problem using Redis or Memcached which are RAM only database that can be "clustered" in multiple application servers.
In my opinion, the use a persistent database (SQL like MySQL or NoSQL like MongoDB) and a cache system like Memcached over it for this kind of application is not useful also in production because the amount of data is too small.

To code the application I spent two afternoons, about 8 hours of work. If we want to convert the hash in a redis storage, probably additional 3-4 hours of works are needed.