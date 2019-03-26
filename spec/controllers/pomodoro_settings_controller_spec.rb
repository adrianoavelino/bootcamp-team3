require 'rails_helper'

RSpec.describe PomodoroSettingsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
  end

  describe 'POST#create' do

    context 'As Logged User' do
      before(:each) do
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

    context 'As User not Logged in' do
      before(:each) do
        @current_user = FactoryBot.create(:user)
      end

      it 'redirect to login' do
        @pomodoro_setting = attributes_for(:pomodoro_setting, user_id: @current_user.id)
        post :create, params: { pomodoro_setting: @pomodoro_setting }
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe ' #destroy' do
    context 'As Logged User' do
      before(:each) do
        sign_in @current_user
      end

      it 'return success' do
        request.env['HTTP_ACCEPT'] = 'application/json'
        @pomodoro_setting = create(:pomodoro_setting, user_id: @current_user.id)
        delete :destroy, params: {id: @pomodoro_setting.id}
        expect(response).to have_http_status(:success)
      end

      it 'change count by -1' do
        request.env['HTTP_ACCEPT'] = 'application/json'
        sign_in @current_user
        @pomodoro_setting = create(:pomodoro_setting, user_id: @current_user.id)
        expect {
          delete :destroy, params: { id: @pomodoro_setting.id }
        }
        .to change(PomodoroSetting, :count).by(-1)
      end
    end

    context 'As User not Logged in' do
      it 'redirect to login' do
        request.env['HTTP_ACCEPT'] = 'application/json'
        @pomodoro_setting = create(:pomodoro_setting, user_id: @current_user.id)
        delete :destroy, params: { id: @pomodoro_setting.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context 'As Logged User' do
      before(:each) do
        @pomodoro_setting = create(:pomodoro_setting, user_id: @current_user.id)
        @pomodoro_setting_updated = attributes_for(:pomodoro_setting, user_id: @pomodoro_setting.user_id)
        sign_in @current_user
        put :update, params: { id: @pomodoro_setting.id, pomodoro_setting: @pomodoro_setting_updated }
      end

      it 'return success' do
        expect(response).to have_http_status(:success)
      end

      it 'member has updated attributes' do
        expect(PomodoroSetting.last.duration).to eq(@pomodoro_setting_updated[:duration])
        expect(PomodoroSetting.last.short_break).to eq(@pomodoro_setting_updated[:short_break])
        expect(PomodoroSetting.last.long_break).to eq(@pomodoro_setting_updated[:long_break])
      end
    end

    context 'As User not Logged in' do
      before(:each) do
        @pomodoro_setting = create(:pomodoro_setting, user_id: @current_user.id)
        @pomodoro_setting_updated = attributes_for(:pomodoro_setting, user_id: @pomodoro_setting.user_id)
        put :update, params: { id: @pomodoro_setting.id, pomodoro_setting: @pomodoro_setting_updated }
      end

      it 'return http unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
