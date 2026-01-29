class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_user
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = @user.tasks
    render json: tasks, status: :ok
  end

  def show
    render json: @task, status: :ok
  end

  def create
    task = @user.tasks.create!(task_params)
    render json: task, status: :created
  end

  def update
    if @task.update!(task_params)
      render json: @task, status: :ok
    end
  end

  def destroy
    @task.destroy
    render json: {message: "Task deleted successfully."}, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:user_id].to_i)

    if @current_user.id != @user.id
      render json: { message: "You are not authorize for this action." }, status: :unauthorized
    end
  end

  def set_task
    @task = @user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :descryption, :status)
  end
end
