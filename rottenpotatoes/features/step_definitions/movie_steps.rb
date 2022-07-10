# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  #fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m
  expect(page.body).to match(regexp)
  #fail "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(/,/)
  ratings.each do |rating|
    if uncheck then
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
  #fail "Unimplemented"
end

Then /I should see all movies with ratings: (.*)/ do |rating_list|
  ratings = rating_list.split(/,/)

  # count records with rating
  count = 0
  ratings.each do |rating|
    count += Movie.where(rating: rating).count
  end

  # count records displayed
  table_count = page.body.scan(/<tr>/).size - 1
  table_count.should be count
end

Then /I shouldn't see any movies with ratings: (.*)/ do |rating_list|
  ratings = rating_list.split(/,/)
  
  # count records with rating
  count = 0
  ratings.each do |rating|
    Movie.where(rating: rating).each do |movie|
      regexp = /#{movie.title}/m
      if page.body =~ regexp then
        count += 1
      end
    end
  end
  
  # count records displayed
  count.should be 0
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  valid_movie = true
  Movie.all.each do |movie|
    regexp = /#{movie.title}/m
    if not page.body =~ regexp then
      valid_movie = false
    end
  end
  
  valid_movie.should be true
end
