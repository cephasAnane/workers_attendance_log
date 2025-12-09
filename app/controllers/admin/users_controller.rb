class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!

    def index
        @users = User.all.order(created_at: :desc)
    end

    def new
        @user = User.new 
    end

    def create 
        @user = User.new(user_params)
        generated_password = user_params[:password].presence || "password123"
        @user.password ||= generated_password
        @user.password_confirmation ||= generated_password

        if @user.save
            UserMailer.with(user: @user, password: generated_password).welcome_email.deliver_later

            redirect_to admin_users_path, notice: "Employee created and email sent successfully."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])

        if params[:user][:password].blank?
            params[:user].delete(:password)
            params[:user].delete(:password_confirmation)
        end

        if @user.update(user_params)
            redirect_to admin_users_path, notice: "Employee updated successfully."
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy 
        @user = User.find(params[:id])
        @user.destroy
        redirect_to admin_users_path, notice: "Employee deleted."
    end

    private

    def ensure_admin!
        redirect_to root_path, alert: "Access Denied!" unless current_user.admin?
    end

    def user_params
        params.require(:user).permit(:email, :full_name, :role, :department_id, :password, :password_confirmation, :hourly_rate)
    end
end
