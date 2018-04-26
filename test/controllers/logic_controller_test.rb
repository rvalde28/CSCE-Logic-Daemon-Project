require 'test_helper'

class LogicControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get logic_home_url
    assert_response :success
  end

  test "should get primer" do
    get logic_primer_url
    assert_response :success
  end

  test "should get quizmaster" do
    get logic_quizmaster_url
    assert_response :success
  end

  test "should get daemon" do
    get logic_daemon_url
    assert_response :success
  end

  test "should get checkers" do
    get logic_checkers_url
    assert_response :success
  end

end
