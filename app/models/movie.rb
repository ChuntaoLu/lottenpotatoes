class Movie < ActiveRecord::Base
  has_many :reviews, :dependent => :destroy
  has_many :moviegoers, :through => :reviews

  @@grandfathered_date = Date.parse '19550101'

  class Movie::InvalidKeyError < StandardError ; end
  class Movie::NoDirectorError < StandardError ; end

  before_save :capitalize_title
  def capitalize_title
    self.title = self.title.split(/\s+/).
        map(&:downcase).map(&:capitalize).join(' ')
  end

  def self.api_key
    "e3a578cf327f30d51162d8aee30b78df"
  end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
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

  def self.find_same_director(id)
    movie = self.find(id)
    if movie.director.nil? or movie.director.blank?
      raise Movie::NoDirectorError, "'#{movie.title}' has no director info"
    else
      self.find_all_by_director(movie.director)
    end
  end

#validation goes below------------------------------------------------
  RATINGS = self.all_ratings#%w[G PG PG-13 R NC-17]  #  %w[] shortcut for array of strings
  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, :inclusion => {:in => RATINGS}, :unless => :grandfathered?

  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
        self.release_date < Date.parse('1 Jan 1930')
  end

  def grandfathered?
    self.release_date != nil && self.release_date <= @@grandfathered_date
  end

end
