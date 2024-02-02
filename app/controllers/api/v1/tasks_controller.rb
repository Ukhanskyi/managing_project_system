module Api
  module V1
    # Tasks Controller
    class TasksController < ApplicationController
      before_action :authenticate_user!
      before_action :set_task, only: [:show, :update, :destroy]

      has_scope :by_status

      # GET /tasks
      def index
        @tasks = apply_scopes(Task).all
        render json: @tasks
      end

      # GET /tasks/1
      def show
        render json: @task
      end

      # POST /tasks
      def create
        @task = Task.new(task_params)

        if @task.save
          render json: @task, status: :created, location: api_v1_task_url(@task)
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /tasks/1
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # DELETE /tasks/1
      def destroy
        @task.destroy
      end

      private

      def set_task
        task_id = params[:id]
        Rails.cache.fetch("task_#{task_id}", expires_in: 1.hour) do
          @task = Task.find(task_id)
        end
      end

      def task_params
        params.require(:task).permit(:name, :description, :status, :project_id)
      end
    end
  end
end
