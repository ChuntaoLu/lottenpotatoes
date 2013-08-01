module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  # highlight the column name by which sort is based on
  def hilite?(column_name)
    "hilite" if params[:sort] == column_name
  end
  # cancel when edit or add new movie
  def cancel
    link_to 'Cancal', @movie.nil? ? movies_path : movie_path(@movie)
  end
end
