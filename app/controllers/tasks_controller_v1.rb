class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      search_results = Task.search({
        query: {
          bool: {
            must: [
              {
                multi_match: {
                  query: params[:query],
                  fields: ["title^3", "descryption", "status"]
                }
              }
            ],
            filter: [
              { term: { user_id: @current_user.id } }
            ]
          }
        }
      })
      tasks = search_results.records.order(created_at: :desc)
    else
      tasks = @current_user.tasks.order(created_at: :desc)
    end

    tasks = tasks.page(params[:page]).per(5)

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

  def create
    @task = @current_user.tasks.create!(task_params)
    @tasks = @current_user.tasks.order(created_at: :desc).page(params[:page]).per(5)
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to users_tasks_path, notice: "Task created." }
      format.json { render json: {task: TaskSerializer.new(@task), message: "Task created." }, status: :created }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    if @task.update!(task_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to users_tasks_path, notice: "Task updated." }
        format.json { render json: {task: TaskSerializer.new(@task), message: "Task updated successfully."}, status: :ok }
      end
    end
  end

  def destroy
    if @task.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: users_tasks_path, notice: "Task was successfully deleted.") }
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
