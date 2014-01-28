# Author: Samir Undavia

##
# This is the User object
class User

    attr_accessor :data

    def initialize
        @data = {} # {movie_id => rating}
    end

    ##
    # adds data to the hash 
    def add movie_id, rating
        data[movie_id] = rating
    end

end