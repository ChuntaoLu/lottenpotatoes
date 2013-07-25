module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  #highlight the column name by which sort is based on
  def hilite?(column_name)
    "hilite" if params[:sort] == column_name
  end

  def sel
    
  end
end
