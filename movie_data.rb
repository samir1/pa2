# Author: Samir Undavia

require "./data_loader"
require "./movie_test"

class MovieData

	def initialize folder, set=nil
		data = DataLoader.new folder,set

		@movieRatingSum = data.getMovieRatingSum # {movie_id => sum of ratings}
		@userMovieRating = data.getUserMovieRating # {user_id => {movie_id => rating}}
		@movieUserRating = data.getMovieUserRating # {movie_id => {user_id => rating}}
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

	def rating u,m
		test = MovieTest.new
	end

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

	def run_test k=nil
		test = MovieTest.new k
	end

end

movie = MovieData.new("ml-100k")
popList = movie.popularity_list
puts "first and last ten elements of popularity list"
puts popList[0...10]
puts "..."
puts popList[popList.length-10..popList.length]
puts
puts
puts "most_similar(1)"
puts movie.most_similar(1)