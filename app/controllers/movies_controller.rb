class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    begin 
      @movie = Movie.find(id) # look up movie by unique ID
    rescue
      flash[:notice] = 'Sorry, no such a movie with the given id.'
      redirect_to movies_path
    end
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.ratings
    if params[:ratings].nil? && session[:ratings].nil?
      params[:ratings] = Hash[@all_ratings.map {|x| [x, 1]}]
    end
    if params[:ratings].nil? && params[:sort].nil?
      params[:ratings] = session[:ratings]
      params[:sort] = session[:sort]
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])
    end
    #debug method in controller(only):
    #raise params.inspect
    @selected = params[:ratings]
    session[:ratings] = params[:ratings]
    session[:sort] = params[:sort]
    @movies = Movie.order(params[:sort]).where(:rating => params[:ratings].keys)       #sort can be nil, condition can't
    #debugger                                           #very useful!!!!!
  end

  def new
    # default: render 'new' template
  end

  def create
    #debugger
    @movie = Movie.create!(params[:movie])
    #raise params[:movie].inspect
    flash[:notice] = "#{@movie.title} was successfully created."
    #redirect_to movies_path
    redirect_to movie_path(@movie)
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
