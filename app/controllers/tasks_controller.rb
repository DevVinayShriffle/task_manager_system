class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = @current_user.tasks
    if tasks.present?
      render json: {tasks: tasks.map {|task| TaskSerializer.new(task)}, message: "All tasks"}, status: :ok
    else  
      render json: {message: "There are no any tasks."}, status: :ok
    end
  end

  def show
    render json: {task: TaskSerializer.new(@task), message: "Task get successfully"}, status: :ok
  end

  def create
    task = @current_user.tasks.create!(task_params)
    render json: {task: TaskSerializer.new(task), message: "Task created successfully."}, status: :created
  end

  def update
    if @task.update!(task_params)
      task = @current_user.tasks.find_by(id: params[:id])
      render json: {task: TaskSerializer.new(task), message: "Task updated successfully"}, status: :ok
    end
  end

  def destroy
    if @task.destroy
      render json: {message: "Task deleted successfully."}, status: :ok
    else
      render json: {message: "Task not deleted."}, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = @current_user.tasks.find_by(id: params[:id])
    render json: {message: "Could not find tasks."}, status: :not_found unless @task
  end

  def task_params
    params.require(:task).permit(:title, :descryption, :status)
  end
end
