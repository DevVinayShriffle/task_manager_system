class UsersController < ApplicationController
  before_action :authorize_request, except: [:create, :login]
  # before_action :find_user, except: [:create]

  # def index
  # end

  # def show
  # end

  def create
    @user = User.create!(user_params)
    set_token
    render json: @user, status: :created
  end

  def update
    user = User.find_by(id: params[:id])
    byebug
    user.update!(password: params[:user][:password])
    render json: {message: "User updated successfully."}
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: {message: "User deleted Successfully."}, status: :ok
  end

  def login
    @user = User.find_by(email: params[:user][:email])
   
    if(@user && @user.authenticate(params[:user][:password]))
      set_token
      render json: { 
        id: @user.id,
        message: 'Logged in successfully',
        email: @user.email,
      }, status: :ok
    else
      render json: {message: "Invalid Credentials."}
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_token
    token = JsonWebToken.encode(user_id: @user.id)
    time = Time.now + 24.hours.to_i
      
    response.headers['Authorization'] = "Bearer #{token}"
  end
end
