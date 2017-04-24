class MentorPolicy
  attr_reader :user, :mentor

  def initialize(user, mentor)
    @user = user
    @mentor = mentor
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