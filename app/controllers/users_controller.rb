class UsersController < ApplicationController
  before_action :authorize_request, :authorize_user, except: [:create, :login]

  def create
    user = User.create!(user_params)
    token = set_token(user)
    render json: {user: UserSerializer.new(user), meta: {token: token, message: "User registered successfully."}}, status: :ok
  end

  def update
    user = User.find_by(id: params[:id])
    user.update!(password: params[:user][:password])
    render json: {user: UserSerializer.new(user), meta: {message: "User updated successfully."}}, status: :ok
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: {message: "User deleted Successfully."}, status: :ok
    else
      render json: {message: "User not deleted."}, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:user][:email].strip.downcase)
   
    if(user && user.authenticate(params[:user][:password]))
      token = set_token(user)
      render json: {user: UserSerializer.new(user), meta: {token: token, message: "Logged in successfully."} }, status: :ok
    else
      render json: {message: "Invalid email or password."}
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_token(user)
    token = JsonWebToken.encode(user_id: user.id)
    token = "Bearer #{token}"
    response.headers['Authorization'] = token
  end
end
