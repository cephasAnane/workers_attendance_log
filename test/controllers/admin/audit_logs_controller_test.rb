require "test_helper"

class Admin::AuditLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_audit_logs_index_url
    assert_response :success
  end
end
