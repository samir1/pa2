# Author: Samir Undavia

class DataLoader

	def initialize folder, set=nil, test=nil
		@movieRatingSum = Hash.new # {movie_id => sum of ratings}
		@userMovieRating = Hash.new # {user_id => {movie_id => rating}}
		@movieUserRating = Hash.new # {movie_id => {user_id => rating}}
		@folder = folder
		@set = set
		@test = test

		load_data
	end

	def load_data
		if @set == nil
			file = "u.data"
		elsif @test == nil
			file = [@set, "base"].join(".")
		else
			file = [@set, "test"].join(".")
		end
		File.foreach @folder + "/#{file}" do |line|
			lineArray = line.split("\t").map(&:to_i)
            if !@movieRatingSum.has_key?(lineArray[1])
                    @movieRatingSum[lineArray[1]] = 0
            end
            @movieRatingSum[lineArray[1]] += lineArray[2]
			if !@userMovieRating.has_key?(lineArray[0])
				@userMovieRating[lineArray[0]] = Hash.new
			end
			@userMovieRating[lineArray[0]][lineArray[1]] = lineArray[2]
			if !@movieUserRating.has_key?(lineArray[1])
				@movieUserRating[lineArray[1]] = Hash.new
			end
			@movieUserRating[lineArray[1]][lineArray[0]] = lineArray[2]
		end
	end

	def getMovieRatingSum
		return @movieRatingSum
	end

	def getUserMovieRating
		return @userMovieRating
	end

	def getMovieUserRating
		return @movieUserRating
	end

end