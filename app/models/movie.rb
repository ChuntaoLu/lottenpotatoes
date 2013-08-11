class Movie < ActiveRecord::Base
  
  class Movie::InvalidKeyError < StandardError ; end
  
  def self.api_key
    "e3a578cf327f30d51162d8aee30b78df"    
  end

  def self.all_ratings
    out = %w(G PG PG-13 NC-17 R)
  end

  def self.find_in_tmdb(string)
    Tmdb.api_key = self.api_key
    begin
      TmdbMovie.find(:title => string)
    rescue ArgumentError => tmdb_error
      raise Movie::InvalidKeyError, tmdb_error.message
    #below deprecated due to tmdb api update
    #rescue RuntimeError => tmdb_error
    #  if tmdb_error =~ /status code '404'/
    #    raise Movie::InvalidKeyError, tmdb_error.message
    #  else
    #    raise RuntimeError, tmdb_error.message
    #  end
    end
  end

end
