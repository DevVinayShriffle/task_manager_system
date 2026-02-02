class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_user
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = @user.tasks
    unless tasks.present?
      render json: {message: "There are no any tasks."}, status: :ok
    else
      # render json: {message: "All tasks:", tasks: tasks, each_serializer: TaskSerializer}, status: :ok
      # render json: tasks.to_a,
      #  serializer: TasksResponseSerializer,
      #  message: "All tasks",
      #  status: :ok

      render json: TaskSerializer.new(tasks).as_json, message: "All tasks", status: :ok

    end
  end

  def show
    # render json: @task, serializer: TaskSerializer, status: :ok
    render json: @task,
      serializer: TaskSerializer,
      message: "Task get successfully.",
      status: :ok
  end

  def create
    task = @user.tasks.create!(task_params)
    render json: {task: TaskSerializer.new(task), meta:{message: "Task created successfully."}}, status: :created
    # render json: task, serializer: TaskSerializer, status: :created
  end

  def update
    task = @task.update!(task_params)
    if task.present?
      render json: {task: TaskSerializer.new(task), meta: {message: "Task updated successfully"}}, status: :ok
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

  def set_user
    @user = User.find(params[:user_id].to_i)

    if @current_user.id != @user.id
      render json: { message: "You are not authorize for this action." }, status: :unauthorized
    end
  end

  def set_task
    @task = @user.tasks.find_by(id: params[:id])
    render json: {message: "Could not find tasks."}, status: :not_found unless @task
  end

  def task_params
    params.require(:task).permit(:title, :descryption, :status)
  end
end
