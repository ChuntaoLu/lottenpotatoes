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
    @all_ratings = Movie.all_ratings
    #----------------workable but ugly code-------------------------
    #sort = params[:ratings].nil? ? sessions[:sort] : params[:ratings]
    #@selected_ratings = params[:ratings]
    #if @selected_ratings.nil?
    #  if sessions[:ratings].nil?
    #    @selected_ratings = Hash[@all_ratings.map {|x| [x, 1]}]
  #  else
    #    @selected_ratings = sessions[:ratings]
    #  end
    #end
    #----------------------------------------------------------------
    # || returns the most left operand if it's true
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering = {:order => :title}
    when 'release_date'
      ordering = {:order => :release_date}
    end
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    if @selected_ratings == {}
      @selected_ratings  = Hash[@all_ratings.map {|rating| [rating, 1]}]
    end
    #if params[:sort] != sessions[:sort] or params[:ratings] != sessions[:ratings]
    #  sessions[:sort] = sort
    #  sessions[:ratings] = @selected_ratings
    #  flash.keep
    #  redirect_to :sort => sort, :ratings => @selected_ratings and return
    #end
    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
    #@movies = Movie.order(sort).where(:rating => @selected_ratings.keys)
    #----------------debug options---------------
    #raise params.inspect   #in controller(only):
    #debugger
    #--------------------------------------------
  end

  def new
    # default: render 'new' template
  end

#  def create
#    #debugger
#    @movie = Movie.create!(params[:movie])
#    #raise params[:movie].inspect
#    flash[:notice] = "#{@movie.title} was successfully created."
#    redirect_to movies_path
#    #redirect_to movie_path(@movie)
#  end

  def create
    @movie = Movie.new(params[:movie])
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    else
      render 'new' # note, 'new' template can access @movie's field values!
    end
  end

  def edit
    #todo show directer on edit page
    @movie = Movie.find params[:id]
  end

#  def update
#    @movie = Movie.find params[:id]
#    @movie.update_attributes!(params[:movie])
#    flash[:notice] = "#{@movie.title} was successfully updated."
#    redirect_to movie_path(@movie)
#  end
  def update
    @movie = Movie.find params[:id]
    if @movie.update_attributes(params[:movie])
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else
      render 'edit' # note, 'edit' template can access @movie's field values!
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end


  def search_tmdb
    title = params[:search_terms]
    @movies = Movie.find_in_tmdb(title)
    if title.nil? or title == ''
      flash[:warning] = 'No title given.'
      redirect_to movies_path and return
    elsif Movie.find_by_title(title).present?
      #TODO highlight existing movie
      redirect_to movies_path and return
    elsif @movies.empty?
      flash[:notice] = "'#{title}' was not found in TMDb."
      redirect_to movies_path and return
    end
  end


  def search_same_director
    begin
      @similar_movies = Movie.find_same_director(params[:id])
      #raise @similar_movies.inspect
      #raise params.inspect
    rescue Exception => error
      flash[:notice] = error.message
      redirect_to root_path and return
    end
  end
end
