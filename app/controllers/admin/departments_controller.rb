class Admin::DepartmentsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!
    before_action :set_department, only: [:edit, :update, :destroy]

    def index
        @departments = Department.all.order(:name)
    end

    def new
        @department = Department.new
    end

    def create
        @department = Department.new(department_params)
        if @department.save
            redirect_to admin_departments_path, notice: "Department created successfully."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @department.update(department_params)
            redirect_to admin_departments_path, notice: "Department updated successfuly."
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        if @department.users.any?
            redirect_to admin_departments_path, alert: "Cannot delete department with active employees."
        else
            @department.destroy
            redirect_to admin_departments_path, notice: "Department deleted."
        end
    end

    private

    def set_department
        @department = Department.find(params[:id])
    end

    def department_params
        params.require(:department).permit(:name, :description)
    end

    def ensure_admin!
        redirect_to root_path, alert: "Access Denied" unless current_user.admin?
    end
end
