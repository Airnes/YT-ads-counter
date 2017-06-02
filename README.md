# YT-ads-counter
Tool telling you if ads were displayed on Youtube video

## Tools
 - brew
 - ruby 2.4
 - Sox
 - chrome
## Instalation
1. cd to project folder
2. run `bundle install`
3. run `brew install sox`

## Run
1. cd to the project folder
2. run `RECORD_TIME=S SOUND_OUTPUT='sound_output_device' cucumber` where S is time in seconds (default value is 60) and sound_output_device is Headphones (default)