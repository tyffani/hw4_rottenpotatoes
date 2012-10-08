require 'spec_helper'

describe Movie do
  describe "Get all ratings" do
    it "should return a list of all ratings" do
      Movie.all_ratings.should == ["G", "PG", "PG-13", "NC-17", "R"]
    end
  end

  describe "Find similar movies" do
    it "should return a list of similar movies by director" do
      movie = Movie.new
      movie.director = "test_director"
      movie.stub(:director).and_return("test_director")
      @fake_result = [movie, mock('movie')]
      Movie.should_receive(:find_all_by_director).with("test_director").and_return(@fake_result)
    end
  end
end


