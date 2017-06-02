
Given /^I am on youtube\.com with adblock on$/ do
  puts 'We are going to watch videos with AdBlock On'
  handle = page.driver.find_window("Adblock Plus has been installed")
  page.driver.browser.switch_to.window(handle)
  visit('/')
end

Given /^I am on youtube\.com with adblock off/ do
  puts 'We are going to watch videos with AdBlock Off'
  visit('/')
  sleep 5
end

And /^I open Trending videos$/ do
  click_link_or_button 'Trending'
  expect(page).to have_content 'Success'
end

And /^I choose video from a input list and see results$/ do
  search_open_and_record_video
end

When /^I enter "([^"]*)"$/ do |term|
  fill_in('q',:with => term)
end

Then /^I should see results$/ do
  page.should have_css('div#res li')
end

And /^I wait for (\d+) seconds$/ do |seconds|
  sleep seconds.to_i
end

Then /^I want to know if there were ads$/ do
  final_result_by_elements
  final_result_by_audio_files
end
