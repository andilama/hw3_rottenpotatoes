# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  rows = 0
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  e1_index = page.body.index(e1)
  e2_index = page.body.index(e2)
  assert e1_index < e2_index
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating.strip}"}
  end
end

Then /I should see all movies/ do
  rows = 0
  db_rows = Movie.count()
  movies = Movie.find(:all)
  movies.each do |movie|
    if page.has_content?(movie[:title])
      rows += 1
    end
  end
  assert rows == db_rows
end
