require 'spec_helper'

describe MoviesController do
  describe "Find all movies with the same director" do
    it "should call a model method that finds all similar movies" do
      movie = Movie.new
      movie.title = "Test"
      movie.save!
      Movie.should_receive(:similar)
      post :similar, {:id => "1"}
    end
  end

  describe "Searching a director" do
    it "should render the right template with the director" do
      movie = Movie.new
      movie.title = "Test"
      movie.director = "Director_test"
      movie.save!
      Movie.stub(:find_by_id).and_return(movie)
      Movie.should_receive(:find_similar).with("Director_test")
      post :search_director, {:id => "1"}
      response.should redirect_to(movies_path)
    end
  end
end
