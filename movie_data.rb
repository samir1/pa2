# Author: Samir Undavia

require_relative 'movie'
require_relative 'user'
require_relative 'load_data'
require_relative 'movie_test'


##
# This is the main MovieData class

class MovieData

    attr_reader :usersData, :moviesData

    def initialize folder=nil, set=nil
        @folder = folder
        @set = set
        dl = LoadData.new folder, set
        dl.load_data
        @usersData = dl.users
        @moviesData = dl.movies
    end

    ##
    # returns the rating that user u gave movie m in the training set, and 0 if user u did not rate movie m
    def rating u,m
        @testData.users[u].data[m] == nil ? 0 : @testData.users[u].data[m]
    end

    ##
    # this will generate a number which indicates the similarity in movie preference between user1 and user2 (where higher numbers indicate greater similarity)
    def similarity user1, user2, users=@usersData
        similar = 0
        for x in users[user1].data.keys
            if users[user2].data.has_key?(x)
                similar += 5-((users[user1].data[x]-users[user2].data[x]).abs)
                if users[user1].data[x] == users[user2].data[x]
                    similar += 5
                end
            end
        end
        similar
    end

    ##
    # this return a list of users whose tastes are most similar to the tastes of user u
    def most_similar u, users=@usersData
        sim = 0
        simArray = Array.new
        for x in users.keys
            if x != u
                currentSim = similarity u, x, users
                if currentSim > sim
                    sim = currentSim
                    simArray = Array.new
                    simArray.push x
                elsif currentSim == sim
                    simArray.push x
                end
            end
        end
        simArray
    end

    ##
    # returns a floating point number between 1.0 and 5.0 as an estimate of what user u would rate movie m
    def predict u, m, users=@usersData
        sum = 0.0
        count = 0
        array = most_similar u, users
        for item in array
            if users[item].data[m] != nil
                count += 1
                sum += users[item].data[m]
            end
        end
        avg = count != 0 ? sum/count : (users[u].data.values.inject(0) {|a,b|a+b})/users[u].data.size
        avg == 0 ? 1 : avg
    end
    
    ##
    # returns the array of movies that user u has watched
    def movies u
        @usersData[u].data.keys
    end
    
    ##
    # returns the array of users that have seen movie m
    def viewers m
        @moviesData[m].data.keys
    end
    
    ##
    # runs the z.predict method on the first k ratings in the test set and returns a MovieTest object containing the results.
    def run_test k=nil
        mt = MovieTest.new
        if @set == nil
            return mt
        end
        @testData = LoadData.new @folder, @set, :test, k
        @testData.load_data
        testUsers = @testData.users
        for u in testUsers.keys
            for m in testUsers[u].data.keys
                p = predict u, m, testUsers
                mt.add u, m, (rating u, m), p
            end
        end
        return mt
    end

end

md = MovieData.new "ml-100k", :u1
mt = md.run_test 1000
puts
puts
puts
puts "Mean: #{mt.mean}"
puts "Std dev: #{mt.stddev}"
puts md.rating 1,6
print md.most_similar(1)