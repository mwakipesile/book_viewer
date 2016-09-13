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

get "/chapters/:number" do |chaptr_num|
  file_name = "data/chp#{chaptr_num}.txt"
  redirect('/') unless File.exist?(file_name)

  @title = "Chapter #{chaptr_num}: #{@table_of_contents[chaptr_num.to_i - 1]}"
  @chapter = in_paragraphs(File.read(file_name))

  erb :chapter
end

get "/search" do
  @search_str = params['query']
  @results = {}

  if @search_str
    @table_of_contents.each.with_index do |title, idx|
      chapter_parags = File.read("data/chp#{idx + 1}.txt").split("\n\n")
      chapter_parags.select! do |pg|
        pg.gsub!(/#{@search_str}/i, "<strong>#{@search_str.downcase}</strong>")
      end

      if chapter_parags.empty?
        @results[idx + 1] = [title] if title.match(/#{@search_str}/i)
      else
        @results[idx + 1] = [title]

        chapter_parags.each do |parag|
          @results[idx + 1] << parag
        end
      end  
    end
  end

  erb :search
end
