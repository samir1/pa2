# Author: Samir Undavia

##
# This is the Movie object
class Movie
    
    attr_accessor :data

    def initialize
        @data = {} # {user_id => rating}
    end

    ##
    # adds data to the hash 
    def add user_id, rating
        data[user_id] = rating
    end

end