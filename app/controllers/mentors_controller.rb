class MentorsController < ApplicationController
  before_action :set_mentor, only: [:show, :edit, :update, :destroy, :save_mentor]
  before_action :redirect_user, only: [:edit, :new, :update_mentor]
  attr_accessor :twitter_client

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = "QmnF0N1nALWJCshk5ecUWXG2n"
      config.consumer_secret     = "N7PoX41YI7YHinZw5qI9XmOskX0nzw60GPtMuQGb7UY6oNh853"
    end
  end

  def update_mentor
    # Set list of mentors to fetch from Twitter. This will be a list from a model
    @approved_list = ['RogerFederer', 'RafaelNadal', 'andy_murray', 'tsonga7', 'DjokerNole ']
    
    @approved_list.each do |player|
      
      # Fetch user from Twitter
      @data = twitter_client.user(player)
      
      # If Mentor exists in db? Just update the fields to get latest user info
      if Mentor.exists?(twitter_id_str: @data[:attrs][:id_str])
        
        # Find the Mentor that needs to be updated
        @mentor = Mentor.where(twitter_id_str: @data[:attrs][:id_str])

        @mentor.update(name:                         @data[:attrs][:name])
        @mentor.update(screen_name:                  @data[:attrs][:screen_name])
        @mentor.update(description:                  @data[:attrs][:description])
        @mentor.update(url:                          @data[:attrs][:url])
        @mentor.update(followers_count:              @data[:attrs][:followers_count])
        @mentor.update(friends_count:                @data[:attrs][:friends_count])
        @mentor.update(profile_background_color:     @data[:attrs][:profile_background_color])
        @mentor.update(profile_background_image_url: @data[:attrs][:profile_background_image_url])
        @mentor.update(profile_banner_url:           @data[:attrs][:profile_banner_url])
        @mentor.update(profile_image_url:            @data[:attrs][:profile_image_url])

      # This Twitter user doesn't exist in db so create one
      else
        Mentor.create(twitter_id_str:               @data[:attrs][:id_str], 
                      name:                         @data[:attrs][:name], 
                      screen_name:                  @data[:attrs][:screen_name],
                      description:                  @data[:attrs][:description],
                      url:                          @data[:attrs][:url],
                      followers_count:              @data[:attrs][:followers_count],
                      friends_count:                @data[:attrs][:friends_count],
                      profile_background_color:     @data[:attrs][:profile_background_color],
                      profile_background_image_url: @data[:attrs][:profile_background_image_url],
                      profile_banner_url:           @data[:attrs][:profile_banner_url],
                      profile_image_url:            @data[:attrs][:profile_image_url],
                      )  
      end
    end

    # Redirect to mentors page and notify user of update
    redirect_to mentors_path
    flash[:alert] = "List updated!"
  end

  
  def mentor_signup

  end



  # GET /mentors
  # GET /mentors.json
  def index
    # @mentors = Mentor.all

    @q = Mentor.ransack(params[:q])
    @mentors = @q.result
  end

  # GET /mentors/1
  # GET /mentors/1.json
  def show
  end

  # GET /mentors/new
  def new
    @mentor = Mentor.new
  end

  # GET /mentors/1/edit
  def edit
  end

  # POST /mentors
  # POST /mentors.json
  def create
    @mentor = Mentor.new(mentor_params)
    authorize @mentor

    respond_to do |format|
      if @mentor.save
        format.html { redirect_to @mentor, notice: 'Mentor was successfully created.' }
        format.json { render :show, status: :created, location: @mentor }
      else
        format.html { render :new }
        format.json { render json: @mentor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mentors/1
  # PATCH/PUT /mentors/1.json
  def update
    authorize @mentor
    respond_to do |format|
      if @mentor.update(mentor_params)
        format.html { redirect_to @mentor, notice: 'Mentor was successfully updated.' }
        format.json { render :show, status: :ok, location: @mentor }
      else
        format.html { render :edit }
        format.json { render json: @mentor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mentors/1
  # DELETE /mentors/1.json
  def destroy
    authorize @mentor
    @mentor.destroy
    respond_to do |format|
      format.html { redirect_to mentors_url, notice: 'Mentor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentor
      @mentor = Mentor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mentor_params
      params.require(:mentor).permit(:twitter_id_str, :name, :screen_name, :description, :url, :followers_count, :friends_count, :profile_background_color, :profile_background_image_url, :profile_banner_url, :profile_image_url)
    end

    def redirect_user
      if user_signed_in? && (current_user.has_role? :admin)
      else
        raise Pundit::NotAuthorizedError, "must be logged in"
      end
    end
end
