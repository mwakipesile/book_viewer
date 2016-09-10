require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  # Alt: File.readlines('data/toc.txt') to array,
  # then use 'each' instead of 'each_line' in views/home.erb
  @author = "Sir Arthur Doyle"
  @contents = File.read('data/toc.txt')
  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @contents = File.readlines("data/toc.txt")
  @chapter = File.read("data/chp1.txt")

  erb :chapter
end