require 'tilt/erubis'
require 'sinatra'
require "sinatra/reloader" if development?

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph, idx|
      "<p id='parag#{idx}'>#{paragraph}</p>"
    end.join("\n\n")
    # {}"<p>#{text.gsub("\n\n", "</p>\n\n<p>")}</p>"
  end

  def search_and_save_results
    @table_of_contents.each.with_index do |title, idx|
      result = paragraphs_or_titles_with_matches(title, idx + 1)
      @results << result if result
    end
  end

  def paragraphs_or_titles_with_matches(title, num)
    pgs = paragraphs_matches_with_ids(num)

    return { number: num, title: title, ids_parags: pgs } unless pgs.empty?
    return { number: num, title: title } if title =~ /#{@query}/i
  end

  def paragraphs_matches_with_ids(number)
    parags = in_paragraphs(File.read("data/chp#{number}.txt")).split("\n\n")

    parags.each_with_index.with_object({}) do |(paragraph, idx), paragraphs|
      pg = paragraph.gsub!(/#{@query}/i, "<strong>#{@query.downcase}</strong>")
      next unless pg
      paragraphs["parag#{idx}"] = pg
    end
  end
end

before do
  @heading = 'Table of Contents'
  @table_of_contents = File.readlines('data/toc.txt')
  @author = 'Sir Arthur Doyle'
end

not_found do
  redirect '/'
end

get '/' do
  @title = 'The Adventures of Sherlock Holmes'
  erb :home
end

get '/chapters/:number' do |chaptr_num|
  file_name = "data/chp#{chaptr_num}.txt"
  redirect('/') unless File.exist?(file_name)

  @title = "Chapter #{chaptr_num}: #{@table_of_contents[chaptr_num.to_i - 1]}"
  @chapter = in_paragraphs(File.read(file_name))

  erb :chapter
end

get '/search' do
  @query = params['query']
  @results = []

  search_and_save_results if @query

  erb :search
end
