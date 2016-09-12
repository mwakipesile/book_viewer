require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

before do
  @heading = 'Table of Contents'
  @table_of_contents = File.readlines("data/toc.txt")
  @author = "Sir Arthur Doyle"
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  chapter_number = params[:number].to_i
  @title = "Chapter #{chapter_number}: #{@table_of_contents[chapter_number - 1]}"
  @chapter = File.read("data/chp#{chapter_number}.txt")

  erb :chapter
end
