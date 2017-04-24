class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  attr_accessor :twitter_client


  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = "QmnF0N1nALWJCshk5ecUWXG2n"
      config.consumer_secret     = "N7PoX41YI7YHinZw5qI9XmOskX0nzw60GPtMuQGb7UY6oNh853"
    end
  end

  def retrieve_tweets
    # Find the question to be referenced
    @question = Question.find(params[:id])

    # Make API call using @question.hashtag
    @data = twitter_client.search('#' + @question.hashtag).take(9)
    
    @data.each do |data|
      # If response tweet exists in db, update all fields besides id.
      if Tweet.exists?(t_id_str: data[:attrs][:id_str])

        @single_tweet = Tweet.where(t_id_str: data[:attrs][:id_str])

        @single_tweet.update(t_text:                 data[:attrs][:text])
        @single_tweet.update(t_user_id_str:          data[:attrs][:user][:id_str])
        @single_tweet.update(t_screen_name:          data[:attrs][:user][:screen_name])
        @single_tweet.update(t_created_at:           data[:attrs][:created_at])

        @single_tweet.update(t_user_prof_img_url:    data[:attrs][:user][:profile_image_url])
        @single_tweet.update(t_user_prof_bg_col:     data[:attrs][:user][:profile_background_color])
        @single_tweet.update(t_user_prof_ban_url:    data[:attrs][:user][:profile_banner_url])
        @single_tweet.update(t_favorite_count:       data[:attrs][:favorite_count])

      # If not in db, create new Tweet
      else
        Tweet.create(t_id_str:                       data[:attrs][:id_str], 
                      t_text:                        data[:attrs][:text], 
                      t_screen_name:                 data[:attrs][:user][:screen_name],
                      t_user_id_str:                 data[:attrs][:user][:id_str],
                      t_user_prof_img_url:           data[:attrs][:user][:profile_image_url],
                      t_user_prof_ban_url:           data[:attrs][:user][:profile_banner_url],
                      t_user_prof_bg_col:            data[:attrs][:user][:profile_background_color],
                      t_favorite_count:              data[:attrs][:favorite_count],
                      t_created_at:                  data[:attrs][:created_at],
                      question_id:                   @question.id
                      )  
      end
    end
    # Redirect to this question path and notify user
    redirect_to question_path(params[:id])
<<<<<<< HEAD
    flash[:alert] = "Updated Tweets"
=======
    flash[:alert] = "Tweets updated!"
>>>>>>> Tidy and comment tweets controller
  end


  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:t_id_str, :t_text, :t_created_at, :t_user_id_str, :t_screen_name, :question_id)
    end
end
