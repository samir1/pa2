# Author: Samir Undavia

class Movie
    
    attr_accessor :data

    def initialize
        @data = {} # {user_id => rating}
    end

    def add user_id, rating
        data[user_id] = rating
    end

    def to_s
        data
    end

end