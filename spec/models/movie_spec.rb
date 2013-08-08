require 'spec_helper'

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
end
