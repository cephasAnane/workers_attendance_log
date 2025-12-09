require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get payments_url
    assert_response :success
  end

  test "should get new" do
    get new_payments_url
    assert_response :success
  end

  test "should get create" do
    post payments_url
    assert_response :success
  end
end
