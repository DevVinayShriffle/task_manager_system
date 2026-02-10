require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  it { should use_before_action(:authorize_request) }
  it { should use_before_action(:set_task) }
  let(:task) {create(:task)}

  describe 'GET#index' do

  end

  describe 'GET#show' do

  end

  describe 'POST#create' do
    context 'with valid params' do
      let(:valid_params) { attributes_for(:task) }

      it 'creates task (HTML)' do
        post :create, params: {task: valid_params}, format: :html

        expect(response).to redirect_to(users_tasks_path(task))
        expect(flash[:notice]).to eq("Task created.")
      end

      it 'creates task (JSON)' do
        post :create, params: {task: valid_params}, format: :json

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["message"]).to eq("Task created.")
        expect(json["task"]).to be_present
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { title: "" }
      context 'when referrer exists' do
        before do
          request.env("HTTP_REFERER") = users_tasks_path
        end

        it "fails creation (HTML)" do
          post :create, params: { task: invalid_params }, format: :html

          expect(response).to redirect_to(users_tasks_path)
          expect(flash[:error]).to be_present
        end

        it "fails creation (JSON)" do
          post :create, params: { task: invalid_params }, format: :json

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'POST#edit' do

  end

  describe 'DELETE#destroy' do

  end
end