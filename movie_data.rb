# Author: Samir Undavia

class MovieData

	def initialize folder, set=nil
		@movieRatingSum = Hash.new # {movie_id => sum of ratings}
		@userMovieRating = Hash.new # {user_id => {movie_id => rating}}
		@movieUserRating = Hash.new # {movie_id => {user_id => rating}}
		@folder = folder
		@set = set
	end

	def load_data
		if @set == nil
			file = "u.data"
		else
			file = [@set, "base"].join(".")
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

	# popularity is the sum of all scores for each movie because if a movie had low scores, but a lot of people rated it, it is sill a popular movie
	def popularity movie_id
		pop = 0
		popArray = @movieUserRating[movie_id].values
		popArray.each { |a| pop+=a }
		return pop
		#return @movieRatingSum[movie_id]
	end

	def popularity_list
		h = @movieRatingSum.sort_by {|k,v| v}.reverse
		list = Array.new
		for x in h
			list.push(x[0])
		end
		return list
	end

	# similarity sees is user1 has any movies rated in common with user2. If there is a common movie rated, 5-(the distance away from the ratings) is added to similarity, so ratings that are closer to each other have a higher similarity
	def similarity user1,user2
		arr1 = @userMovieRating[user1]
		arr2 = @userMovieRating[user2]
		similar = 0
		for x in arr1.keys
			if arr2.has_key?(x)
				similar += 5-((arr1[x]-arr2[x]).abs)
			end
		end
		return similar
	end

	def most_similar u
		sim = 0
		user = 0
		for x in @userMovieRating.keys
			if x != u
				currentSim = similarity(u,x)
				if currentSim > sim
					sim = currentSim
					user = x
				end
			end
		end
		return user
	end

	#def rating u,m

	def predict u,m
		if @userMovieRating[most_similar(u)].has_key?(m)
			return @userMovieRating[most_similar(u)][m]
		else
			predict(most_similar(u),m)
		end
	end

	def movies u
		return @userMovieRating[u].keys
	end

	def viewers m
		return @movieUserRating[m].keys
	end

	#def run_test k

end

movie = MovieData.new("ml-100k")
movie.load_data
popList = movie.popularity_list
puts "first and last ten elements of popularity list"
puts popList[0...10]
puts "..."
puts popList[popList.length-10..popList.length]
puts
puts
puts "most_similar(1)"
puts movie.most_similar(1)