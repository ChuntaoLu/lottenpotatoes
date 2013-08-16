require 'spec_helper'


describe MoviesController do

  describe 'show movie detail' do
    it 'should call model method on Movie given movie exist' do
      fake_movie = double('movie', :id => 1)
      Movie.should_receive(:find).and_return(fake_movie)
      get :show, {:id => 1}
    end
    it 'should flash meassage and go back to home page if movie not found' do
      lambda {  Movie.find(1) }.should raise_error
      get :show, {:id => 1}
      flash[:notice].should == 'Sorry, no such a movie with the given id.'
      response.should redirect_to movies_path
    end
  end

  describe 'sort movie list' do
    render_views
    before :each do
      @movie1 = FactoryGirl.create(:movie, :title => 'Amelie', :rating => 'G', :release_date => '2001')
      @movie2 = FactoryGirl.create(:movie, :title => 'Aladdin', :rating => 'G', :release_date => '2012')
    end

    it 'should pass params to Movie' do
      get :index, :ratings => {'G' => '1'}, :sort => 'title'
      controller.params[:sort].should == 'title'
      controller.params[:ratings].should == {'G' => '1'}
      assigns(:selected_ratings).should ==  {'G' => '1'}
    end

    it 'should sort by params[:sort]' do
      Movie.stub(:find_all_by_rating).and_return([@movie2, @movie1])
      get :index
      assigns(:movies).should == [@movie2, @movie1]
      response.body.should =~ /.*Aladdin.*Amelie/m
    end


    it 'should render the right view template' do
      get :index
      response.should render_template('index')
    end

    after :each do
      @movie1.destroy
      @movie2.destroy
    end
  end

  describe 'creat a movie' do
    it 'should flash a message on a successful save' do
      post :create
      assigns(:movie).should_not be_new_record
      flash[:notice].should_not be_nil
      response.should redirect_to movies_path
    end

    it 'should pass params to Movie' do
      post :create, :movie => {:title => 'fake'}
      assigns(:movie).title.should == 'fake'
    end
  end

  describe 'edit a movie' do
    before :each do
      @fake_movie = FactoryGirl.build(:movie, :id => 1, :title => 'Ha')
    end
    it 'should pass movie id to Movie' do
      Movie.should_receive(:find).and_return(@fake_movie)
      get :edit, :id => 1
      assigns(:movie).should == @fake_movie
    end

    it 'should update movie' do
      Movie.should_receive(:find).and_return(@fake_movie)
      @fake_movie.should_receive(:update_attributes!)
      put :update, :id => 1
      flash[:notice].should_not be_nil
      response.should redirect_to movie_path
    end
  end

  describe 'delete a movie' do
    it 'should delete a movie' do
      fake_movie = FactoryGirl.build(:movie, :id => 1, :title => 'Ha')
      Movie.should_receive(:find).and_return(fake_movie)
      fake_movie.should_receive(:destroy)
      delete :destroy, :id => 1
      assigns(:movie).should == fake_movie
      flash[:notice].should_not be_nil
      response.should redirect_to movies_path
    end
  end

  describe 'searching TMDb' do

    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end

    it 'should call the model method that performs TMDb search' do
      Movie.should_receive(:find_in_tmdb).with('hardware').
        and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
    end

    describe 'after valid search' do
      before :each do
        Movie.stub(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('search_tmdb')
      end
      it 'should make the TMDb search results available to that template' do
        assigns(:movies).should == @fake_results
      end
    end

    describe 'search none-exist movie' do
      it 'should redirect to the home page' do
        Movie.stub(:find_in_tmdb).with('movie that does not exists').
          and_return([])
        post :search_tmdb, {:search_terms => 'movie that does not exists'}
        response.should redirect_to movies_path
      end
    end

    describe 'search movie that exists in RottenPotatoes' do
      it 'should redirect to the home page' do
        Movie.should_receive(:find_by_title).with('Amelie').and_return(@fake_results)
        post :search_tmdb, {:search_terms => 'Amelie'}
        response.should redirect_to movies_path
      end
    end

    describe 'search without giving a title' do
      it 'should flash a warning' do
        Movie.stub(:find_by_title).with('')
        post :search_tmdb, {:search_terms => ''}
        flash[:warning].should == 'No title given.'
      end
    end
  end

  describe 'find movies with same director' do

    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end

    it 'should call the model method that performs search for same director movies' do
      Movie.should_receive(:find_same_director).and_return(@fake_results)
      get :search_same_director, {:id => 1}
    end

    describe 'after valid search' do
      before :each do
        Movie.stub(:find_same_director).and_return(@fake_results)
        get :search_same_director, {:id => 1}
      end
      it 'should select the Search Results template for rendering' do
        response.should  render_template('search_same_director')
      end
      it 'should make the search for same director movies available to that template' do
        assigns(:similar_movies).should == @fake_results
      end
    end

    describe 'current movie has no director info' do
      it 'should redirect to home page' do
        movie = double('movie', :id => 1, :director => '')
        Movie.should_receive(:find_same_director).and_raise(Movie::NoDirectorError)
        get :search_same_director, {:id => 1}
        response.should redirect_to root_path
      end
    end

  end

end
