class TweetPolicy
  attr_reader :user, :tweet

  def initialize(user, tweet)
    @user = user
    @tweet = tweet
  end

  def create?
    user.has_role? :admin
  end
  
  def update?
    user.has_role? :admin
  end
  
  def destroy?
    user.has_role? :admin
  end

end