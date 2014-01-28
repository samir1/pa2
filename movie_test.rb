# Author: Samir Undavia

##
# This class holds the results of the predictions

class MovieTest

    attr_accessor :results

	def initialize
        @results = []
    end

    ##
    # adds an array of data to @results
    def add u,m,r,p
        @results.push [u,m,r,p]
    end

    ##
    # returns the average predication error (which should be close to zero)
    def mean
        sum = 0.0
        for arr in @results
            error = ((arr[2]-arr[3])/arr[2]).abs
            sum += error
        end
        return (sum/@results.size)
    end

	##
    # returns the standard deviation of the error
    def stddev
        m = mean
        sum = 0.0
        for arr in @results
            sum += (((((arr[2]-arr[3])/arr[2]).abs)-m)**2)
        end
        return (Math.sqrt(sum/@results.size))
    end

	##
    # returns the root mean square error of the prediction
    def rms
        Math.sqrt(mean**2)
    end

    ##
    # returns an array of the predictions in the form [u,m,r,p]
	def to_a
        @results
    end

end