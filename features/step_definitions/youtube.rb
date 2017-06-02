
Given /^I am on youtube\.com with adblock on$/ do
  puts 'We are going to watch videos with AdBlock On'
  handle = page.driver.find_window("Adblock Plus has been installed")
  page.driver.browser.switch_to.window(handle)
  sleep 5
  visit('/')
end

Given /^I am on youtube\.com with adblock off/ do
  puts 'We are going to watch videos with AdBlock Off'
  visit('/')
  sleep 5
end

And /^I choose video from a input list and see results$/ do
  search_open_and_record_video
end
