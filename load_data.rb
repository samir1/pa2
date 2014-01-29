# Author:  Samir Undavia

require_relative 'movie'
require_relative 'user'

##
# This class loads data from the files 
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

    ##
    # returns filename
    def filename
        if @set.nil?
            file = "u.data"
        elsif @test == nil
            file = [@set, "base"].join(".")
        else
            file = [@set, "test"].join(".")
        end
        file
    end

	##
    # loads data from file
    def load_data
        file = filename
		thisK = @k
        File.foreach @folder + "/#{file}" do |line|
            if thisK != nil
            	thisK == 0 ? break : thisK -= 1
            end
            lineArray = line.split("\t").map(&:to_i)
            load_to_users_and_movies lineArray
        end
    end

    ##
    # loads data to users hash and movies hash
    def load_to_users_and_movies lineArray
        uId = lineArray[0]
        mId = lineArray[1]
        rating = lineArray[2]
        if !@users.has_key? uId
            @users[uId] = User.new
        end
        @users[uId].add mId, rating
        if !@movies.has_key? mId
            @movies[mId] = Movie.new
        end
        @movies[mId].add uId, rating
    end

end