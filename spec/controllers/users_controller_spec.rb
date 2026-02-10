require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it { should use_before_action(:authorize_request) }

  # describe 'POST #create' do
  #   context 'valid credentials' do
  #     let(:valid_params) {{user:{email: "delete@gmail.com", password:"Del@12"}}}
  #     it "returns the correct HTML format" do
  #       post :create, params: valid_params, format: :html
  #       expect(response).to redirect_to(users_tasks_path)
  #       expect(flash[:notice]).to eq("User registered successfully.")
  #     end

  #     it "returns the correct JSON format" do
  #       post :create, params: valid_params, format: :json #making request
  #       expect(response).to have_http_status(:ok)

  #       json = JSON.parse(response.body )
  #       expect(json["meta"]["message"]).to eq("User registered successfully.")
  #       expect(json).to have_key('user')
  #       expect(json['meta']['token']).to be_present
  #       expect(json['meta']['token']).to be_a(String)
  #       # expect(json[:meta]).to have_key(:token)
  #     end
  #   end

  #   context 'invalid credentials' do
  #     let(:invalid_params) {{user:{email: "test@example.com", password: "wrongpassword"}}}
  #     it "returns the correct HTML format" do
  #       post :create, params: invalid_params, format: :html
  #       expect(response).to redirect_to('users#create')
  #       # expect(flash[:notice]).to eq("User registered successfully.")
  #       expect(flash[:error]).to include("Validation failed")
  #     end

  #     it "returns the correct JSON format" do
  #       post :create, params: invalid_params, format: :json #making request
  #       expect(response).to have_http_status(:unprocessable_entity)

  #       json = JSON.parse(response.body )
  #       expect(flash[:error]).to include("Validation failed")
  #     end
  #   end
  # end

  # describe 'PATCH #update' do
  #   context 'valid credentials' do
  #     let(:valid_params) {{user:{password:"Del@12"}}}
  #     it "returns the correct HTML format" do
  #       post :update, params: valid_params, format: :html
  #       expect(response).to redirect_to(users_tasks_path)
  #       expect(flash[:notice]).to eq("Password updated.")
  #     end

  #     it "returns the correct JSON format" do
  #       post :update, params: valid_params, format: :json #making request
  #       expect(response).to have_http_status(:ok)

  #       json = JSON.parse(response.body )
  #       expect(json["meta"]["message"]).to eq("User updated successfully.")
  #       expect(json).to have_key('user')
  #     end
  #   end
  # end

  # describe 'DELETE #destroy' do
  #   context 'when the user is successfully destroyed' do
  #     # expect {
  #     #   delete :destroy, params: { id: user.id }
  #     # }.to change(User, :count).by(-1)

  #     it 'returns the correct html format' do
  #       post :destroy, format: :html
  #       expect(response).to redirect_to(root_path)
  #       expect(flash[:notice]).to eq("User deleted Successfully.")
  #     end

  #     it 'returns the correct JSON format' do
  #       post :destroy, format: :json #making request
  #       expect(response).to have_http_status(:ok)

  #       json = JSON.parse(response.body )
  #       expect(json["message"]).to eq("User deleted successfully.")
  #     end
  #   end
  # end

  # describe 'POST #login' do
  #   context 'valid credentials' do
  #     let(:valid_params) {{user:{email: "delete@gmail.com", password:"Del@12"}}}
  #     it "returns the correct HTML format" do
  #       post :login, params: valid_params, format: :html
  #       expect(response).to redirect_to(users_tasks_path)
  #       expect(flash[:notice]).to eq("Logged in successfully.")
  #     end

  #     it "returns the correct JSON format" do
  #       post :login, params: valid_params, format: :json #making request
  #       expect(response).to have_http_status(:ok)

  #       json = JSON.parse(response.body )
  #       expect(json["meta"]["message"]).to eq("Logged in successfully.")
  #       expect(json).to have_key('user')
  #       expect(json['meta']['token']).to be_present
  #       expect(json['meta']['token']).to be_a(String)
  #       # expect(json[:meta]).to have_key(:token)
  #     end
  #   end
  # end

  # describe 'DELETE #logout' do

  #   context 'when the user is successfully logout' do
  #     # expect(session[:token]).to be_nil
  #     it 'returns the correct html format' do
  #       session[:token] = "valid_token_123"
  #       delete :logout, format: :html
  #       # byebug
  #       # expect(session[:token]).to be_nil
  #       expect(response).to redirect_to(root_path(form: "login"))
  #       expect(flash[:notice]).to eq("Logged out successfully.")
  #     end

  #     it 'returns the correct JSON format' do
  #       session[:token] = "valid_token_123"
  #       delete :logout, format: :json
  #       # expect(session[:token]).to be_nil
  #       expect(response).to have_http_status(:ok)

  #       json = JSON.parse(response.body )
  #       expect(json["message"]).to eq("Logged out successfully.")
  #     end
  #   end
  # end

  let!(:user) {create(:user)}
  let(:token) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

  before do
    session[:token] = token
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) { attributes_for(:user) }

      it "creates user (HTML)" do
        post :create, params: { user: valid_params }, format: :html

        expect(response).to redirect_to(users_tasks_path)
        expect(flash[:notice]).to eq("User registered successfully.")
      end

      it "creates user (JSON)" do
        post :create, params: { user: valid_params }, format: :json

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["meta"]["message"]).to eq("User registered successfully.")
        expect(json["meta"]["token"]).to be_present
        expect(json["user"]).to be_present
      end
    end

    context "invalid params" do
      let(:invalid_params) { { email: "", password: "" } }
      context "when referrer exists" do
        before do
          request.env["HTTP_REFERER"] = users_path
        end

        it "fails creation (HTML)" do
          post :create, params: { user: invalid_params }, format: :html

          expect(response).to redirect_to(users_path)
          expect(flash[:error]).to be_present
        end

        it "fails creation (JSON)" do
          post :create, params: { user: invalid_params }, format: :json

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "PATCH #update" do
    context "valid password" do
      it "updates password (HTML)" do
        patch :update, params: { user: { password: "New@12" } }, format: :html

        expect(response).to redirect_to(users_tasks_path)
      end

      it "updates password (JSON)" do
        patch :update, params: { user: { password: "New@12" } }, format: :json

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["message"]).to eq("User updated successfully.")
      end
    end

    context "invalid password" do
      context "when referrer exists" do
        before do
          request.env["HTTP_REFERER"] = users_path
        end

        it "fails update (HTML)" do
          patch :update, params: {user: { password: "wrongpassword" } }, format: :html

          expect(response).to redirect_to(users_path)
          expect(flash[:error]).to be_present
        end

        it "fails update (JSON)" do
          patch :update, params: {user: { password: "wrongpassword" } }, format: :json

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "DELETE #destroy" do

    it "destroys user (HTML)" do
      expect {
        delete :destroy, format: :html
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("User deleted Successfully.")
    end

    it "destroys user (JSON)" do
      delete :destroy, format: :json

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["message"]).to eq("User deleted Successfully.")
    end
  end

  describe "POST #login" do

    context "valid credentials" do
      it "logs in (HTML)" do
        post :login, params: { user: { email: user.email, password: user.password } }, format: :html

        expect(response).to redirect_to(users_tasks_path)
        expect(flash[:notice]).to eq("Logged in successfully.")
      end

      it "logs in (JSON)" do
        post :login, params: { user: { email: user.email, password: user.password } }, format: :json

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json["meta"]["token"]).to be_present
      end
    end

    context "invalid credentials" do
      it "fails login (HTML)" do
        post :login, params: { user: { email: user.email, password: "wrong" } }, format: :html

        expect(flash[:error]).to eq("Invalid email or password.")
      end

      it "fails login (JSON)" do
        post :login, params: { user: { email: user.email, password: "wrong" } }, format: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #logout" do

    it "logs out (HTML)" do
      delete :logout, format: :html

      expect(session[:token]).to be_nil
      expect(response).to redirect_to(root_path(form: "login"))
      expect(flash[:notice]).to eq("Logged out successfully.")
    end

    it "logs out (JSON)" do
      delete :logout, format: :json

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["message"]).to eq("Logged out successfully.")
    end
  end
end