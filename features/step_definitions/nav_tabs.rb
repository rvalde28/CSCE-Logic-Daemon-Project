# to Run, use this resource
#https://github.com/cucumber/cucumber/wiki/Running-Features

#using regex expr to get the string passed in by scenario template
#using 'expect', 'have_attributes' from Rspec

Given(/^user is on (.*) page$/) do |route|
  #go to page1
  visit(route)
end

When(/^user clicks to go to the (.*?) page$/) do |link|
  #check to see if page1 (application layout) has a link to page2 and click it
  
  #need to get at below file where the link is, however it is a layout layered
  #above the current page, current page is just the content section of below
  #/app/views/layouts/application.html.erb
  #:application.find(link).click
  visit(link)
  #find(link).click
end

Then(/^user should see that they are on the (.*) page$/) do |route2|
  #check that we are on the correct page
  expect(page). to have_content(route2)
end