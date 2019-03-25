require 'rails_helper'

RSpec.describe PomodoroSettingsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'POST#create' do
    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context 'As Logged User' do
      before(:each) do
        @current_user = FactoryBot.create(:user)
        sign_in @current_user
      end

      it 'return http found' do
        request.env['HTTP_ACCEPT'] = 'application/json'
        @pomodoro_setting = attributes_for(:pomodoro_setting, user_id: @current_user.id)
        post :create, params: { pomodoro_setting: @pomodoro_setting }
        expect(response).to have_http_status(:success)
      end

      it 'change count by 1' do
        request.env['HTTP_ACCEPT'] = 'application/json'

        @pomodoro_setting = attributes_for(:pomodoro_setting, user_id: @current_user.id)
        expect {
          post :create, params: { pomodoro_setting: @pomodoro_setting }
        }
        .to change(PomodoroSetting, :count).by(1)
      end
    end
  end

end
