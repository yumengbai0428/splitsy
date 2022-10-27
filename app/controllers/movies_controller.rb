class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_movies = Movie.all
    @all_ratings = self.all_ratings()
    @ratings_to_show = @all_ratings.to_a
    flag_redirect = false

    if params.has_key?("ratings")
      @ratings_to_show = []
      rats = params["ratings"]
      ratings = params["ratings"]
      rats.each{ |rating, val|
        @ratings_to_show.append(rating)
      }
    elsif session.has_key?("ratings") and not(params.has_key?("newsubmit"))
      @ratings_to_show = []
      params["ratings"] = session["ratings"]
      rats = session["ratings"]
      ratings = session["ratings"]
      flag_redirect = true
      rats.each{ |rating, val|
        @ratings_to_show.append(rating)
      }
    else
      ratings = []
    end

    if params.has_key?("sort")
      sort = params["sort"]
    elsif session.has_key?("sort")
      flag_redirect = true
      params["sort"] = session["sort"]
      sort = session["sort"]
    else 
      sort = nil
    end

    if sort == "title"
      @title_class = "hilite bg-warning"
      @date_class = ""
    elsif sort == "release_date"
      @date_class = "hilite bg-warning"
      @title_class = ""
    else
      @title_class = ""
      @date_class = ""
    end

    @movies = Movie.with_ratings_and_sorting(@ratings_to_show, sort)

    session["sort"] = sort
    session["ratings"] = ratings

    if flag_redirect
      session.clear()
      redirect_to movies_path(params)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def all_ratings
    require 'set'
    temp = Set[]
    @all_movies.each{ |movie|
      temp.add(movie.rating)
    }
    return temp
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
