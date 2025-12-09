require "test_helper"

class Admin::AuditLogsControllerTest < ActionDispatch::IntegrationTest
  # 1. Include the Devise helpers so we can sign in
  include Devise::Test::IntegrationHelpers

  setup do
    # 2. Sign in as the user 'one' from your fixtures
    sign_in users(:one)
  end

  test "should get index" do
    get admin_audit_logs_url # Ensure this route helper is correct!
    assert_response :success
  end
end