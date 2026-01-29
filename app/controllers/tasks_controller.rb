class TasksController < ApplicationController
  def index
    tasks = current_user.tasks
    render json: tasks, status: :ok
  end

  def show
    # task = current_user.tasks.find(params[:id])
    render json: @task, status: :ok
  end

  def create
    task = current_user.tasks.create!(task_params)
    render json: task, status: :created
  end

  def update
    # task = current_user.tasks.find(params[:id])
    @task.update!(task_params)
    render json: task, status: :ok
  end

  def destroy
    # task = current_user.tasks.find(params[:id])
    @task.destroy
    render json: {message: "Task deleted successfully."}, status: :ok
  end

  private
  def task_params
    params.require(:task).permit(:title, :descryption, :status)
  end

  def find_task
    @task = current_user.tasks.find(params[:id])
  end
end
