module MentorsHelper

	def set_bg(model)
		"background-image:url(#{model.profile_banner_url});
		background-position: center center;
		background-repeat: no-repeat;
		background-size: cover;"
	end


	def set_tweet_bg(model)
		"background-image:url(#{model.t_user_prof_img_url});
		background-position: center center;
		background-repeat: no-repeat;
		background-size: cover;"
	end

end
