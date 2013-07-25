class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    #if params[:ratings].present?
    #  @selected = params[:ratings].keys
    #  #session[:ratings] = @selected
    #elsif  session[:ratings].present?
    #  @selected = session[:ratings]
    #else
    #  @seletecd = @all_ratings
    #end
    #session[:ratings] = @selected
    @all_ratings = Movie.ratings
    if params[:ratings].nil?                           #first visit
      @selected = @all_ratings                         #default all checked
      condition = { :rating => @all_ratings }          #no restrict for ratings
    else                                               #then ratings selected
      @selected = params[:ratings]                     #remain checked after refresh
      condition = { :rating => params[:ratings].keys } #rating restrict
    end
    #when sort link clicked, params[:sort] becomes available, sort != nil
    sort = params[:sort]                               #sort choice    
    @movies = Movie.order(sort).where(condition)       #sort can be nil, condition can't
    #debugger                                           #very useful!!!!!
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
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
