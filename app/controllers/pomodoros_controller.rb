class PomodorosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pomodoro, only: [:update]

  def create
    @pomodoro = Pomodoro.new(pomodoro_params)
    respond_to do |format|
      if @pomodoro.save
        format.json { render json: @pomodoro }
      else
        format.json { render json: @pomodoro.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @pomodoro.update(pomodoro_params)
        format.json { render json: true }
      else
        format.json { render json: @pomodoro_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def pomodoro_params
    params.require(:pomodoro).permit(:status, :date, :task_id)
  end


    def set_pomodoro
      @pomodoro = Pomodoro.find(params[:id])
    end
end
