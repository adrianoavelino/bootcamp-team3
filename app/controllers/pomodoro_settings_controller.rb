class PomodoroSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_member, only: [:destroy]

  def create
    @pomodoro_setting = PomodoroSetting.new(pomodoro_setting_params)
    respond_to do |format|
      if @pomodoro_setting.save
        format.json { render json: @pomodoro_setting }
      else
        format.json { render json: @pomodoro_setting.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @pomodoro_setting.destroy
    respond_to do |format|
      format.json { render json: true }
    end
  end

  def pomodoro_setting_params
    params.require(:pomodoro_setting).permit(:duration, :short_break, :long_break, :user_id)
  end

  def set_member
    @pomodoro_setting = PomodoroSetting.find(params[:id])
  end
end
