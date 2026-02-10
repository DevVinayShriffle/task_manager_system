require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) {create(:user)}
  # let!(:token) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
  # # let(:decoded) { JsonWebToken.decode(token.split.last) }
  # let(:current_user) { User.find(decoded[:user_id]) }

  it { should use_before_action(:authorize_request) }
  it { should use_before_action(:set_task) }
  # let(:task) {create(:task)}
  let!(:task) {create(:task, user: user)}
  
  before do
    # @token = "Bearer #{JsonWebToken.encode(user_id: user.id)}"
    # response.headers["Authorization"] = "Bearer #{JsonWebToken.encode(user_id: user.id)}"
    # headers = { "Authorization" => "Bearer #{JsonWebToken.encode(user_id: user.id)}" }
    session[:token] = "Bearer #{JsonWebToken.encode(user_id: user.id)}"
  end

  describe 'GET#index' do
    it 'index task (HTML)' do
      get :index, format: :html
      expect(response).to have_http_status(:ok)
    end

    context 'tasks exist' do
      before do
        create_list(:task, 3)
        get :index, format: :json
      end

      it 'returns tasks' do
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["tasks"]).to be_present
      end
    end

    context 'no tasks exist' do
      before do
        Task.destroy_all
        get :index, format: :json
      end

      it 'returns no task' do
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["message"]).to eq("No tasks")
      end
    end

    # it 'index task (JSON)' do
    #   get :index, format: :json
    #   json = JSON.parse(response.body)

    #   expect(response).to have_http_status(:ok)

    #   context 'have many tasks' do
    #     expect(json["tasks"]).to be_present
    #   end

    #   context 'have no tasks' do
    #     expect(json["message"]).to eq("No tasks")
    #   end
    # end
  end

  describe 'GET#show' do
    it 'show task (HTML)' do
      get :show, params: {id: task.id}, format: :html
      expect(response).to have_http_status(:ok)
      # expect(assigns(:task)).to eq(task)
    end

    it 'show task (JSON)' do
      get :show, params: {id: task.id}, format: :json

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["task"]).to be_present
      expect(json["message"]).to eq("Task get successfully.")
    end
  end

  describe 'POST#create' do
    context 'with valid params' do
      let(:valid_params) { attributes_for(:task) }

      it 'creates task (HTML)' do
        post :create, params: {task: valid_params}, format: :html
        # byebug
        created_task = Task.last
        expect(response).to redirect_to(users_task_path(created_task))
        expect(flash[:notice]).to eq("Task created.")
      end

      it 'creates task (JSON)' do
        post :create, params: {task: valid_params}, format: :json
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json["message"]).to eq("Task created.")
        expect(json["task"]).to be_present
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { {title: ""} }
      context 'when referrer exists' do
        before do
          request.env["HTTP_REFERER"] = users_tasks_path
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

  describe 'PATCH#update' do
    context 'with valid params' do
      let(:valid_params) { attributes_for(:task) }

      it 'update task (HTML)' do
        patch :update, params: {id: task.id, task: valid_params}, format: :html

        expect(response).to redirect_to(users_task_path(task))
        expect(flash[:notice]).to eq("Task updated.")
      end

      it 'update task (JSON)' do
        patch :update, params: {id: task.id, task: valid_params}, format: :json

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["message"]).to eq("Task updated successfully.")
        expect(json["task"]).to be_present
      end
    end

    context 'with invalid params' do
      let(:invalid_params) {{ title: "" }}
      context 'when referrer exists' do
        before do
          request.env["HTTP_REFERER"] = users_task_path(task)
        end

        it "fails update (HTML)" do
          patch :update, params: {id: task.id, task: invalid_params }, format: :html

          expect(response).to redirect_to(users_task_path(task))
          expect(flash[:error]).to be_present
        end

        it "fails update (JSON)" do
          patch :update, params: {id: task.id, task: invalid_params }, format: :json

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'DELETE#destroy' do
    it 'destroy task (HTML)' do
      expect {
        delete :destroy, params: {id: task.id}, format: :html
      }.to change(Task, :count).by(-1)

      expect(response).to redirect_to(users_tasks_path)
      expect(flash[:notice]).to eq("Task deleted.")
    end

    it 'destroy task (JSON)' do
      delete :destroy, params: {id: task.id}, format: :json

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["message"]).to eq("Task deleted.")
    end
  end
end