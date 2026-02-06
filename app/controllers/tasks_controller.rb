class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    tasks = @current_user.tasks.order(created_at: :desc)
    # if tasks.present?
    #   render json: {tasks: tasks.map {|task| TaskSerializer.new(task)}, message: "All tasks"}, status: :ok
    # else  
    #   render json: {message: "There are no any tasks."}, status: :ok
    # end
    respond_to do |format|
      format.html { @tasks = tasks }
      format.json do
        if tasks.present?
          render json: {tasks: tasks.map {|t| TaskSerializer.new(t)}}
        else
          render json: {message: "No tasks"}
        end
      end
    end
  end

  def show
    # render json: {task: TaskSerializer.new(@task), message: "Task get successfully"}, status: :ok
    respond_to do |format|
      format.html { @task = @task }
      format.json { render json: {task: TaskSerializer.new(@task)} }
    end
  end

  def create
    task = @current_user.tasks.create!(task_params)
    # render json: {task: TaskSerializer.new(task), message: "Task created successfully."}, status: :created
    respond_to do |format|
      format.html { redirect_to users_task_path(task), notice: "Task created." }
      format.json { render json: {task: TaskSerializer.new(task)}, status: :created }
    end
  end

  def update
    if @task.update!(task_params)
      # task = @current_user.tasks.find_by(id: params[:id])
      # render json: {task: TaskSerializer.new(task), message: "Task updated successfully"}, status: :ok
      respond_to do |format|
        format.html { redirect_to users_task_path(@task), notice: "Task updated." }
        format.json { render json: {message: "Task updated"} }
      end
    end
  end

  def destroy
    if @task.destroy
        # render json: {message: "Task deleted successfully."}, status: :ok
      # else
        # render json: {message: "Task not deleted."}, status: :unprocessable_entity
      respond_to do |format|
        format.html { redirect_to users_tasks_path, notice: "Task deleted." }
        format.json { render json: {message: "Task deleted"} }
      end
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
