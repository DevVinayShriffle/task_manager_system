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
    user = User.find_by(params[:email])
    user.update!(params[:password])
  end

  def destroy
    user = User.find_by(params[:email])
    user.destroy
    render json: {message: "User deleted Successfully."}, status: :ok
  end

  def login
    # user_params
    @user = User.find_by(email: params[:user][:email])
   
    if(@user && @user.authenticate(params[:user][:password]))
      # token = JsonWebToken.encode(user_id: @user.id)
      # time = Time.now + 24.hours.to_i
      
      # response.headers['Authorization'] = "Bearer #{token}"
      set_token
      render json: { 
        message: 'Logged in successfully',
        email: @user.email,
      }, status: :ok
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
