class Admin::AnalyticsController < ApplicationController
  def index
    @a = [["Language", 'Speakers (in millions)'], ['German',  5.85], ['French',  1.66], ['Italian', 0.316], ['Romansh', 0.0791]]
    @b = [['Общая сумма', 'Месяц', "style"], [10000, '2021-03', "#b87333"], [9595959, '2021-04', "silver"], [88999999, '2021-05', "gold"], [100000, '2021-06', "gold"]]
  end
end
