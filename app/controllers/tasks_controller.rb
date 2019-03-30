class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token

  def index
    @tasks = current_user.tasks
    render json: @tasks, status: :ok
  end

  def show
    render json: @task, status: :ok
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: {
        id: @task.id,
        description: @task.description,
        pomodoros: @task.pomodoros
        }, status: :ok
    else
      render json: @task.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :status, :category, :date, :user_id)
  end

end
