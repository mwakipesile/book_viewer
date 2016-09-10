require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  # Alt: File.readlines('data/toc.txt') to array,
  # then use 'each' instead of 'each_line' in views/home.erb
  @contents = File.read('data/toc.txt') 
  erb :home
end
