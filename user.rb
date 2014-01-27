# Author: Samir Undavia

class User

    attr_accessor :data

    def initialize
        @data = {} # {movie_id => rating}
    end

    def add movie_id, rating
        data[movie_id] = rating
    end

    def to_s
        data
    end

end