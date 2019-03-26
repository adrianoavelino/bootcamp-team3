require 'rails_helper'

RSpec.describe PomodorosController, type: :controller do
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
        @task = create(:task)
        @pomodoro = attributes_for(:pomodoro, task_id: @task.id)
        post :create, params: { pomodoro: @pomodoro }
        expect(response).to have_http_status(:success)
      end

      it 'change count by 1' do
        request.env['HTTP_ACCEPT'] = 'application/json'

        @task = create(:task)
        @pomodoro = attributes_for(:pomodoro, task_id: @task.id)
        expect {
          post :create, params: { pomodoro: @pomodoro }
        }
        .to change(Pomodoro, :count).by(1)
      end
    end

    context 'As User not Logged in' do
      it 'redirect to login' do
        @task = create(:task)
        @pomodoro = attributes_for(:pomodoro, task_id: @task.id)
        post :create, params: { pomodoro: @pomodoro }
        expect(response).to redirect_to(user_session_path)
      end
    end
  end


    describe 'PUT #update' do
      before(:each) do
        request.env['HTTP_ACCEPT'] = 'application/json'
      end

      context 'As Logged User' do
        before(:each) do
          @task = create(:task)
          @pomodoro = create(:pomodoro, task_id: @task.id)
          @pomodoro_updated = attributes_for(:pomodoro, task_id: @task.id)
          sign_in @current_user
          put :update, params: { id: @pomodoro.id, pomodoro: @pomodoro_updated }
        end

        it 'return success' do
          expect(response).to have_http_status(:success)
        end

        it 'member has updated attributes' do
          expect(Pomodoro.last.status).to match("#{@pomodoro_updated[:status]}")
          expect(Pomodoro.last.task_id).to match(@pomodoro_updated[:task_id])
          expect(Pomodoro.last.date.strftime("%d-%m-%Y %H:%M:%S")).to eq(@pomodoro_updated[:date].strftime("%d-%m-%Y %H:%M:%S"))
        end
      end

      context 'As User not Logged in' do
        before(:each) do
          @task = create(:task)
          @pomodoro = attributes_for(:pomodoro, task_id: @task.id)
          post :create, params: { pomodoro: @pomodoro }
        end

        it 'return http unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end


end
