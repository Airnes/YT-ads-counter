require 'selenium-webdriver'

Capybara.app_host = "https://www.youtube.com"

Capybara.default_driver = :chrome_adblock

Capybara.register_driver :chrome_adblock do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome,
                                   :desired_capabilities => Selenium::WebDriver::Remote::Capabilities.chrome({'chromeOptions' => {'extensions' => [Base64.strict_encode64(File.open('Adblock-Plus_v1.13.2.crx', 'rb').read)]}}))
  end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Before ('@disable_adblock') do
  puts 'Chrome running without AdBlock now'
  Capybara.current_session.driver.quit
  Capybara.current_driver = :chrome
end

After do |scenario|
  system ("killall -9 sox")
  system ("rm -rf *.wav ")
end