class Admin::AuditLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @versions = PaperTrail::Version.order(created_at: :desc).limit(50).includes(:item)
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Access Denied" unless current_user.admin?
  end
end
