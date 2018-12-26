class MixesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sources
  end

  def getTopStories
    # Get data using News API's library
    newsapi = News.new(ENV['NEWS_API_KEY'])
    top_stories = newsapi.get_top_headlines(sources: Mix.default_sources, language: 'en', sortBy: 'publishedAt')
    # mix = Mix.new(top_stories)
    render json: top_stories
  end

  def getSearchStories
    searchTerm = params['_json']
    # Get data using News API's library
    newsapi = News.new(ENV['NEWS_API_KEY'])
    all_stories = newsapi.get_everything(q: searchTerm, sources: Mix.default_sources, language: 'en', sortBy: 'publishedAt')
    # exclude nytimes 'briefings'
    @filtered_stories = all_stories.select {|story| !story.title.include? "Briefing" }
    render json: @filtered_stories.as_json
  end
end
