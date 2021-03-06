class RecommendationsController < ApplicationController



  def create
    yelp = Adapter::YelpWrapper.new
    nearby_recs=[]

    recommendation_array = yelp.initiate_api_req(params["latitude"], params["longitude"], yelp.categories)
    Recommendation.previous_search = true
    recommendation_array.flatten!.each do |one_rec|
      unless Recommendation.find_by(url: one_rec.url)
        rec=Recommendation.new(name:one_rec.name, url:one_rec.url)
        one_rec.categories.each do |category_array|
          if Activity.all.any?{|activity|activity.name==category_array[0]}
            rec.activities<<Activity.find_by(name:category_array[0])
            rec.save
          end
        end
      end
      nearby_recs<<Recommendation.all.find_by(url: one_rec.url)
      #array of all the activity recommendations nearby 
    end

    Recommendation.filtered_array=(yelp.filter_api(nearby_recs, params['doNotWant'])) #the filtered array of rec objects


    #we could make line 16 through 21 wrapped inside a SQL method?
    recommendation=Recommendation.filtered_array.sample
        respond_to do |f|
          f.json {
            render json: {name:recommendation.name, url:recommendation.url}
          }
        end
  end


  def show
    recommendation=Recommendation.filtered_array.sample
    respond_to do |f|
      f.json {
        render json: {name:recommendation.name, url:recommendation.url}
      }
    end
  end


  def add_user_liked_activity
    rec = Recommendation.find_by(url:params[:like_business_link])
    unless current_user.recommendations.any?{|recommendation| recommendation.url == rec.url}
      current_user.recommendations << rec
    end
  end



end
