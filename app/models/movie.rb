class Movie < ActiveRecord::Base
    def self.with_ratings_and_sorting(rating_list, sort)
        if (rating_list == nil or rating_list.length == 0) and sort == nil
            Movie.all
        elsif rating_list != nil  and sort == nil
            Movie.where('rating in (?)', rating_list)
        elsif (rating_list == nil or rating_list.length == 0)  and sort != nil
            Movie.order(sort)
        else
            Movie.where('rating in (?)', rating_list).order(sort)
        end
    end
end
