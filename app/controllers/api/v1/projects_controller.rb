module Api
  module V1
    # Projects Controller
    class ProjectsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_project, only: [:show, :update, :destroy]
      before_action :authorize_user!, only: [:update, :destroy]

      # GET /projects
      def index
        @projects = Project.all
        render json: @projects
      end

      # GET /projects/1
      def show
        render json: @project
      end

      # POST /projects
      def create
        @project = current_user.projects.new(project_params)

        if @project.save
          render json: @project, status: :created, location: api_v1_project_url(@project)
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /projects/1
      def update
        if @project.update(project_params)
          render json: @project
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      end

      # DELETE /projects/1
      def destroy
        @project.destroy
      end

      private

      def set_project
        @project = Project.find_by(id: params[:id])
        render json: { error: 'Project not found' }, status: :not_found unless @project
      end

      def project_params
        params.require(:project).permit(:name, :description, :user_id)
      end

      def authorize_user!
        unless @project.user_id == current_user.id
          render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
        end
      end
    end
  end
end
