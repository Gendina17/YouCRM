class Admin::AnalyticsController < ApplicationController
  def index
    @a = [["Language", 'Speakers (in millions)'], ['German',  5.85], ['French',  1.66], ['Italian', 0.316], ['Romansh', 0.0791]]
  end
end
