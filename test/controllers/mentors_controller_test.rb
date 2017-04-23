require 'test_helper'

class MentorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mentor = mentors(:one)
  end

  test "should get index" do
    get mentors_url
    assert_response :success
  end

  test "should get new" do
    get new_mentor_url
    assert_response :success
  end

  test "should create mentor" do
    assert_difference('Mentor.count') do
      post mentors_url, params: { mentor: { description: @mentor.description, followers_count: @mentor.followers_count, friends_count: @mentor.friends_count, name: @mentor.name, profile_background_color: @mentor.profile_background_color, profile_background_image_url: @mentor.profile_background_image_url, profile_banner_url: @mentor.profile_banner_url, profile_image_url: @mentor.profile_image_url, screen_name: @mentor.screen_name, twitter_id_str: @mentor.twitter_id_str, url: @mentor.url } }
    end

    assert_redirected_to mentor_url(Mentor.last)
  end

  test "should show mentor" do
    get mentor_url(@mentor)
    assert_response :success
  end

  test "should get edit" do
    get edit_mentor_url(@mentor)
    assert_response :success
  end

  test "should update mentor" do
    patch mentor_url(@mentor), params: { mentor: { description: @mentor.description, followers_count: @mentor.followers_count, friends_count: @mentor.friends_count, name: @mentor.name, profile_background_color: @mentor.profile_background_color, profile_background_image_url: @mentor.profile_background_image_url, profile_banner_url: @mentor.profile_banner_url, profile_image_url: @mentor.profile_image_url, screen_name: @mentor.screen_name, twitter_id_str: @mentor.twitter_id_str, url: @mentor.url } }
    assert_redirected_to mentor_url(@mentor)
  end

  test "should destroy mentor" do
    assert_difference('Mentor.count', -1) do
      delete mentor_url(@mentor)
    end

    assert_redirected_to mentors_url
  end
end
