class WelcomeController < ApplicationController
  def hello
  	gon.chicago_total_crime = Crime.get_chicago_total_crime.values
  	gon.uptown_total_crime = Crime.get_uptown_total_crime.values
  	gon.westloop_total_crime = Crime.get_westloop_total_crime.values
  	
    gon.chicago_permit = Permit.get_chicago_permits.values
    gon.uptown_permit = Permit.get_uptown_permits.values
    gon.westloop_permit = Permit.get_westloop_permits.values

    gon.chicago_crime_distribution = Crime.get_chicago_crime_distribution.values
    gon.uptown_crime_distribution = Crime.get_uptown_crime_distribution.values
    gon.westloop_crime_distribution = Crime.get_westloop_crime_distribution.values

    gon.years = Crime.get_chicago_total_crime.keys
  end

  def trends
    if request.xhr?
      topic_title = params[:topic].gsub(/-/, " ")
      current_topic = Topic.find_by(title: topic_title)
      if current_topic #if the topic is found
        dates = current_topic.popularities.map{|p| p.day.date}
        mindate = dates[0]
        maxdate = dates[-1]
        trends = current_topic.popularities.map{|p| p.google_trend_index}
        render :json => {status: 200, dates: [mindate, maxdate], trends: trends}
      else
        render :json =>  {status: 404}
      end
    end
  end
end
