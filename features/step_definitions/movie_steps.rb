# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #flunk "Unimplemented"
  
  # String index comparison
  first = page.body.index(e1)
  second = page.body.index(e2) 
  assert second > first

end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(/\,/)
  ratings.each do |r|
    if uncheck
      uncheck(("ratings_"+r).gsub(/\s+/,""))
    else
      check(("ratings_"+r).gsub(/\s+/,""))
    end
  end
end

When /I click on (.*)/ do |refresh|
  click_button(refresh) 
end

Then /I should see movies with ratings: (.*)/ do |ratings|
  num_movies = 0
  ratings_list = ratings.split(/\,/)
  ratings_list.each do |rating|
    r = rating.gsub(/\s+/, "")
    rated_movies = Movie.find_all_by_rating(r)
    num_movies += rated_movies.count
  end
  assert page.all('table#movies tbody tr').count == num_movies, "num rows != num movies" 
  
end


Then /I should not see movies with ratings: (.*)/ do |ratings|
  num_movies = 0
  ratings_list = ratings.split(/\,/)
  ratings_list.each do |rating|
    r = rating.gsub(/\s+/, "")
    rated_movies = Movie.find_all_by_rating(r)
    num_movies += rated_movies.count
  end
  assert page.all('table#movies tbody tr').count == Movie.all.count - num_movies, "Seeing wrong number of movies"
  """
  rated_movies = Movie.find_all_by_rating(ratings_list)
  num_movies = rated_movies.size
  num_rows = page.all(:css, 'table#movies tr').length
  assert num_rows == num_movies
  """
end  

Then /I should see all of the movies/ do
  num_movies= Movie.all.count
  assert page.all("table#movies tbody tr").count == num_movies, "there are not correct amount of movies for all movies"
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  assert !page.body[%r{Details about #{arg1}}].nil?
  assert !page.body[%r{Director:.*#{arg2}$}m].nil?
end
