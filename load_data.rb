# Author:  Samir Undavia

require './movie.rb'
require './user.rb'

class LoadData

	attr_reader :users, :movies

	def initialize folder, set, test=nil, k=nil
		@folder = folder
		@set = set
		@test = test
		@k = k
		@users = {}
		@movies = {}
	end

	# loads data from file
    def load_data
        if @set == nil
			file = "u.data"
		elsif @test == nil
			file = [@set, "base"].join(".")
		else
			file = [@set, "test"].join(".")
		end
		thisK = @k
        File.foreach @folder + "/#{file}" do |line|
            if thisK != nil
            	thisK == 0 ? break : thisK -= 1
            end
            lineArray = line.split("\t").map(&:to_i)
            loadToUsers lineArray
            loadToMovies lineArray
        end
    end

    # loads data to users hash
    def loadToUsers lineArray
        uId = lineArray[0]
        mId = lineArray[1]
        rating = lineArray[2]
        if !@users.has_key? uId
            @users[uId] = User.new
        end
        @users[uId].add mId, rating
    end

    # loads data to movies hash
    def loadToMovies lineArray
        uId = lineArray[0]
        mId = lineArray[1]
        rating = lineArray[2]
        if !@movies.has_key? mId
            @movies[mId] = Movie.new
        end
        @movies[mId].add uId, rating
    end

end