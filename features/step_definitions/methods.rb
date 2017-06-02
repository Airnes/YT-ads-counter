RECORD_TIME = ENV['RECORD_TIME'].to_i

$list_of_videos = ['The Show Must Go On': 'Queen - The Show Must Go On (Official Video)',
                   'My Life ft. Lil Wayne': 'The Game - My Life ft. Lil Wayne',
                   '10 Ways to Make Passive Income Online': '10 Ways to Make Passive Income Online']
                   # 'Uptown Funk': 'Mark Ronson - Uptown Funk ft. Bruno Mars',
                   # 'Shake It Off': 'Taylor Swift - Shake It Off',
                   # 'Sugar': 'Maroon 5 - Sugar',
                   # 'Bailando':'Enrique Iglesias - Bailando (Español) ft. Descemer Bueno, Gente De Zona',
                   # 'Blank Space': 'Taylor Swift - Blank Space',
                   # 'Dark Horse': 'Katy Perry - Dark Horse (Official) ft. Juicy J',
                   # 'Hello': 'Adele - Hello',
                   # 'Counting Stars': 'OneRepublic - Counting Stars']

$videos_with_ads = []

def wait_to_see_search_result(author, title)
    puts "I'm looking for #{title} Title for #{author} author"
    expect(page).to have_text title
end

def plz_be_quiet
  if find('.ytp-mute-button')['title'] == 'Mute'
    page.find('.ytp-mute-button').click
    puts 'shhh!'
  end
end

def get_current_video_id
  url = URI.parse(current_url).to_s
  video_id = url.partition('=').last
  return video_id
end

def select_video(title)
  first(:link, title).click
  expect(page).to have_text 'Add to'
  # plz_be_quiet
end

def get_current_time
  current_time = Time.strptime((page.find('.ytp-time-current').text),"%H:%S")
  return current_time
end

def get_video_duration
  # duration = Time.strptime((page.find('.ytp-time-duration').text),"%H:%S")
  label_time = (page.find('.ytp-time-duration').text).split(":")
  duration = label_time[0].to_i * 60 + label_time[1].to_i
  return duration
end

def is_ads_displaying
  if page.has_selector?('.videoAdUiAttribution')
    return true
  elsif page.has_text?('.videoAdUiSkipButtonExperimentalText') == 'Skip Ad'
    return true
  end
end

def audio_recording
  file_name = get_current_video_id
  record_time = get_video_duration
  puts "Content duration is #{record_time} seconds"

  if is_ads_displaying
    file_name = get_current_video_id + '-ads'
    record_time = RECORD_TIME + record_time
  elsif record_time > 60
    record_time = RECORD_TIME
  end

  system ("sox -t coreaudio \"Boom2Device\" -d #{file_name}.wav trim 0 #{record_time} &")
end

def skip_ad
  if is_ads_displaying
    page.has_selector?('.videoAdUiSkipButtonExperimentalText', wait: 10)
    page.find('.videoAdUiSkipButtonExperimentalText').click
    hover
  end
end

#workaroud to avoid hiding controls
def hover
  next_btn = page.find('.ytp-play-button')
  mute_btn = page.find('.ytp-mute-button')
  page.driver.browser.action.move_to(next_btn.native).perform
  page.driver.browser.action.move_to(mute_btn.native).perform
end

def wait_for_one_minute
  finish_time = get_current_time + RECORD_TIME
  hover
  #let's start audio recording
  audio_recording

  if is_ads_displaying
    $videos_with_ads.push("'#{get_current_video_id}': 'true'")
    skip_ad
  end

  while get_current_time < finish_time
    hover
    sleep 1
    hover
  end
  system ("killall -9 sox")
end

def click_next_video
  page.find('.ytp-next-button').click
  sleep 5
end

def disable_adblock
  return true
end

def search_open_and_record_video
  $list_of_videos[0].each do |author, title|
    puts "Author is #{author}, Title is #{title}"
    fill_in('masthead-search-term',:with => author)
    click_link_or_button 'Search'
    sleep 5
    wait_to_see_search_result(author,title)
    select_video(title)
    wait_for_one_minute
    final_result_by_elements
    final_result_by_audio_files
  end
end

def final_result_by_elements
  puts 'Here is the results based on Ads elements on screen'
  if $videos_with_ads.empty?
    puts 'No Ads found'
  else
    puts "Youtube videos which were displaying with ads #{$videos_with_ads}"
  end
end

def final_result_by_audio_files
  puts 'Here is results based on recorded audio files'
end
#sox nkGWAc9hUC8-ads.wav -n stat