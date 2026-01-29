class UsersController < ApplicationController
  def index
  end

  def show
  end

  def create
    user = User.create!(user_params)
    render json: user, status: :created
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

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
