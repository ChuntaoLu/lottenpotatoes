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
    @all_ratings = Movie.ratings
    #----------------workable but urgly code-------------------------
    #sort = params[:ratings].nil? ? session[:sort] : params[:ratings]
    #@selected = params[:ratings]
    #if @selected.nil?
    #  if session[:ratings].nil?
    #    @selected = Hash[@all_ratings.map {|x| [x, 1]}]
    #  else
    #    @selected = session[:ratings]
    #  end
    #end
    #----------------------------------------------------------------
    # || returns the most left operand if it's true
    sort = params[:sort] || session[:sort]
    @selected = params[:ratings] || session[:ratings] || {}
    if @selected == {}
      @selected = params[:ratings] = Hash[@all_ratings.map {|x| [x, 1]}]
    end
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected
      #flash.keep
      redirect_to :sort => sort, :ratings => @selected and return
    end
    @movies = Movie.order(sort).where(:rating => @selected.keys)
    #----------------debug options---------------
    #raise params.inspect   #in controller(only):
    #debugger
    #--------------------------------------------
  end

  def new
    # default: render 'new' template
  end

  def create
    #debugger
    @movie = Movie.create!(params[:movie])
    #raise params[:movie].inspect
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
    #redirect_to movie_path(@movie)
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


  def search_tmdb
    @movies = Movie.find_in_tmdb(params[:search_terms])
    # hardwire to simulate failure
#    title = params[:search_terms]
#    if title == ''
#      flash[:warning] = 'No title given.'
#      redirect_to movies_path
#    else
#      @movie = Movie.find_by_title(title)
#      if @movie.present?
#        redirect_to movie_path(@movie)
#      else
#        flash[:warning] = "'#{title}' was not found in TMDb."
#        redirect_to movies_path
#      end
#    end
  end

end
