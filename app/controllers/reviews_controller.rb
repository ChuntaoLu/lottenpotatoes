class ReviewsController < ApplicationController
  before_filter :has_moviegoer_and_movie, :only => [:new, :create, :show, :edit, :update, :destroy]

protected

  def has_moviegoer_and_movie
    unless @current_user
      flash[:warning] = 'You must log in to create a review.'
      #todo alert to login ask if redirect
      redirect_to movie_path(@movie) if (@movie = Movie.find_by_id(params[:movie_id]))
    end
    unless (@movie = Movie.find_by_id(params[:movie_id]))
      flash[:warning] = 'Review must be for an existing movie.'
      redirect_to movies_path
    end
  end

  def find_review_by_user_and_movie(user, movie)
    review = Review.find_all_by_moviegoer_id(user) &
        Review.find_all_by_movie_id(movie)
    review.empty? ? nil : review[0]
  end

public

  def index
    @movie = Movie.find_by_id(params[:movie_id])
    if @movie.reviews.empty?
      flash[:notice] = "#{@movie.title} has not been reviewed yet."
      redirect_to movie_path(@movie)
    else
      @review = find_review_by_user_and_movie(@current_user, @movie) if @current_user
      @reviews = @movie.reviews
    end
  end

  def show
    @review = find_review_by_user_and_movie(@current_user, @movie)
  end

  def new
    if find_review_by_user_and_movie(@current_user, @movie).nil?
      @review = @movie.reviews.build
    else
      flash[:warning] = "You already reviewed #{@movie.title}."
      redirect_to movie_reviews_path(@movie)
    end
  end

  def create
    # since moviegoer_id is a protected attribute that won't get
    # assigned by the mass-assignment from params[:review], we set it
    # by using the << method on the association.  We could also
    # set it manually with review.moviegoer = @current_user.

    @current_user.reviews << @movie.reviews.build(params[:review])
    redirect_to movie_reviews_path(@movie)
  end

  #todo implement other functionality of reviews
  def edit
    @review = find_review_by_user_and_movie(@current_user, @movie)
  end

  def update
    @review = find_review_by_user_and_movie(@current_user, @movie)
    @review.update_attributes(params[:review])
    redirect_to movie_reviews_path(@movie)
  end

  def destroy
    @review = find_review_by_user_and_movie(@current_user, @movie)
    @review.destroy
    flash[:notice] = 'Your review is deleted.'
    if @movie.reviews.empty?
      redirect_to movie_path(@movie)
    else
      redirect_to movie_reviews_path(@movie)
    end
  end

end

