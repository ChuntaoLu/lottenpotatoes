require 'spec_helper'


#FactoryGirl.define do
#  factory :movie do
#    title 'A Fake Title' # default values
#    rating 'PG'
#    release_date { 10.years.ago }
#  end
#end

describe Movie do
  describe 'searching Tmdb by keyword' do
    it 'should call Tmdb with title keyword given valid API key' do 
      TmdbMovie.should_receive(:find).
        with(hash_including :title => 'Inception')
      Movie.find_in_tmdb('Inception')
    end
    it 'should raise an InvalidKeyError with invalid API key' do
      Movie.stub(:api_key).and_return('')
      lambda { Movie.find_in_tmdb('Inception') }.
        should raise_error(Movie::InvalidKeyError)
    end
    #below deprecated due to tmdb api update
    #it 'should raise an InvalidKeyError with invalid API key' do
    #  TmdbMovie.stub(:find).
    #    and_raise(RuntimeError.new("API returned status code '404'"))
    #  lambda { Movie.find_in_tmdb('Inception') }.
    #    should raise_error(Movie::InvalidKeyError)
    #end
  end

  describe 'find movies of same director' do
    it "should call find_all_by_director with movie1's director and return movie1 and movie2" do
      movie1 = double('movie', :id => 1, :director => 'Jack')
      movie2 = double('movie', :id => 2, :director => 'Jack')
      Movie.should_receive(:find).with(1).and_return(movie1)
      Movie.should_receive(:find_all_by_director).with('Jack').and_return([movie1, movie2])
      Movie.find_same_director(1).should == [movie1, movie2]
    end
    it 'should raise error if current movie has no director info' do
      movie = double('movie', :id => 1, :title => 'Fake Movie', :director => nil)
      Movie.should_receive(:find).with(1).and_return(movie)
      lambda {Movie.find_same_director(1)}.
        should raise_error(Movie::NoDirectorError, "'Fake Movie' has no director info" )
    end
    it 'should raise error if current movie director info is invalid' do
      movie = double('movie', :id => 1, :title => 'Fake Movie', :director => '   ')
      Movie.should_receive(:find).with(1).and_return(movie)
      lambda {Movie.find_same_director(1)}.
        should raise_error(Movie::NoDirectorError, "'Fake Movie' has no director info" )
    end
  end

end
