class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :redirect_user, only: [:edit, :new, :retrieve_tweets]
  attr_accessor :twitter_client


  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TW_ID"]
      config.consumer_secret     = ENV["TW_SECRET"]
    end
  end

  def retrieve_tweets
    # Find the question to be referenced
    @question = Question.find(params[:id])
    
    # Temporary approved ids 
    # @approved_ids = ['297380894', '1337785291', '344634424', '14123683', '259925559', '835566090839175169']
    @mentors = Mentor.all
    @approved_list = @mentors.map {|mentor| mentor.twitter_id_str}
    puts @approved_list

    # Make API call using @question.hashtag
    @data = twitter_client.search('#' + @question.hashtag).take(30)
    
    @data.each do |data|
      # If response tweet exists in db, update all fields besides id.
      if Tweet.exists?(t_id_str: data[:attrs][:id_str])

        @tweet = Tweet.where(t_id_str: data[:attrs][:id_str])

        @tweet.update(t_text:                 data[:attrs][:text])
        @tweet.update(t_user_id_str:          data[:attrs][:user][:id_str])
        @tweet.update(t_screen_name:          data[:attrs][:user][:screen_name])
        @tweet.update(t_created_at:           data[:attrs][:created_at])

        @tweet.update(t_user_prof_img_url:    data[:attrs][:user][:profile_image_url])
        @tweet.update(t_user_prof_bg_col:     data[:attrs][:user][:profile_background_color])
        @tweet.update(t_user_prof_ban_url:    data[:attrs][:user][:profile_banner_url])
        @tweet.update(t_favorite_count:       data[:attrs][:favorite_count])

      # If not in db, create new Tweet
      # elsif @approved_list.include?(data[:attrs][:user][:id_str])
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
      # else
      #   puts 'No expected response from Twitter API'  
      end
    end
    # Redirect to this question path and notify user
    redirect_to question_path(params[:id])
    flash[:alert] = "Tweets updated!"
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
    authorize @tweet

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
    authorize @tweet
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
    authorize @tweet
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

    def redirect_user
      if user_signed_in? && (current_user.has_role? :admin)
      else
        raise Pundit::NotAuthorizedError, "must be logged in"
      end
    end
end
