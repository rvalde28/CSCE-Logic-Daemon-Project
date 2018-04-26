def place_input
  click_button val
end


### GIVEN ###
#defined in nav_tabs.rb

### WHEN ###
When (/^user clicks on the (.*) button$/) do |button|
  click_button button
end

### THEN ###
Then (/^user should see (.*) in the input area$/) do |input|
  page.should have_content input
end

Then (/^user should see A in the input area$/) do
  page.should have_content "A"
end

Then (/^user should see that the input area is cleared$/) do
  page.input.should be_empty
end

Then (/^user should see 1 less character in the input area$/) do
  # will change when val evolves
  page.should_not have_content "B"
end

### AND ###
And (/^there is something in the input area$/) do
  # will change when val evolves, A B should be put in the input field
  click_button val
  click_button val
end