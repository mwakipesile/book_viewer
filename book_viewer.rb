require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

helpers do
  def in_paragraphs(text)     
    # text.split("\n\n").map { |paragraph| "<p>#{paragraph}</p>" }.join("\n\n")
    "<p>#{text.gsub("\n\n", "</p>\n\n<p>")}</p>"
  end
end

before do
  @heading = 'Table of Contents'
  @table_of_contents = File.readlines("data/toc.txt")
  @author = "Sir Arthur Doyle"
end

not_found do
  redirect '/'
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do |chapter_num|

  begin
    chapter = File.read("data/chp#{chapter_num}.txt")
  rescue
    redirect('/')
  end

  @title = "Chapter #{chapter_num}: #{@table_of_contents[chapter_num.to_i - 1]}"
  @chapter = in_paragraphs(chapter)

  erb :chapter
end

get "/search" do
  @search_str = params['query']
  @results = []

  if @search_str
    found_indices = []
    @chapter_count = @table_of_contents.size
    @table_of_contents.each.with_index do |title, idx|
      found_indices << idx if title.match(/#{@search_str}/i)
    end

    @chapter_count.times do |idx|
      next if found_indices.include?(idx)

      chapter = File.read("data/chp#{idx + 1}.txt")
      found_indices << idx if chapter.match(/#{@search_str}/i)
    end

    @results = found_indices.map { |idx| @table_of_contents[idx]}
  end
  erb :search
end
