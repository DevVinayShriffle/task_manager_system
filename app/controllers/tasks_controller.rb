class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # def new
  #   @task = Task.new
  # end

  def index
    tasks = @current_user.tasks.order(created_at: :desc).page(params[:page]).per(5)
    respond_to do |format|
      format.html { @tasks = tasks }
      format.json do
        if tasks.present?
          render json: {tasks: tasks.map {|t| TaskSerializer.new(t)}}, status: :ok
        else
          render json: {message: "No tasks"}, status: :ok
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.html { @task }
      format.json { render json: {task: TaskSerializer.new(@task), message: "Task get successfully."}, status: :ok }
    end
  end

  # def create
  #   task = @current_user.tasks.create!(task_params)
  #   respond_to do |format|
  #     # format.html { redirect_to users_task_path(task), notice: "Task created." }
  #     format.html { redirect_to users_tasks_path, notice: "Task created." }
  #     format.turbo_stream
  #     format.json { render json: {task: TaskSerializer.new(task), message: "Task created." }, status: :created }
  #   end
  # end

  # def create
  #   @user = @current_user
  #   # Use build to associate, then save to persist
  #   @task = @user.tasks.build(task_params)

  #   respond_to do |format|
  #     if @task.save
  #       format.html { redirect_to users_tasks_path, notice: 'Task created.' }
  #       # format.html { redirect_to users_tasks_path, notice: 'Task created.' }
  #       format.turbo_stream do
  #         render turbo_stream: [
  #           # 1. Prepend new task to the list
  #           turbo_stream.prepend("tasks-container", partial: "tasks/task", locals: { task: @task }),
  #           # 2. Clear the form by re-rendering it with a new task object
  #           turbo_stream.update("new_task_form", partial: "tasks/new_form", locals: { user: @user, task: @user.tasks.new })
  #         ]
  #       end
  #       format.json { render json: {task: TaskSerializer.new(@task), message: 'Task created.' }, status: :created }
  #     else
  #       # Handle validation errors
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.turbo_stream do
  #         render turbo_stream: turbo_stream.update("new_task_form", partial: "tasks/new_form", locals: { user: @user, task: @task })
  #       end
  #     end
  #   end
  # end

  def create
    @task = @current_user.tasks.build(task_params)
    if @task.save
      # Broadcast is handled by model, but you can explicitly respond
      respond_to { |format| format.turbo_stream }
    end
  end


  def update
    if @task.update!(task_params)
      respond_to do |format|
        format.html { redirect_to users_task_path(@task), notice: "Task updated." }
        format.json { render json: {task: TaskSerializer.new(@task), message: "Task updated successfully."}, status: :ok }
      end
    end
  end

  def destroy
    if @task.destroy
      respond_to do |format|
        format.html { redirect_to users_tasks_path, notice: "Task deleted." }
        format.json { render json: {message: "Task deleted."}, status: :ok }
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
