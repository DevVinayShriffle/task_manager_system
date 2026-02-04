class UsersController < ApplicationController
  before_action :authorize_request, except: [:create, :login, :new]

  def new
    @user = User.new
  end

  # def create
  #   user = User.create!(user_params)
  #   token = set_token(user)
  #   render json: {user: UserSerializer.new(user), meta: {token: token, message: "User registered successfully."}}, status: :ok
  # end

  def create
    @user = User.create!(user_params)
    token = set_token(@user)
    respond_to do |format|
      format.html {redirect_to login_users_path, notice: "User registered successfully."}
      format.json {render json: {user: UserSerializer.new(@user), meta: {token: token, message: "User registered successfully."}}, status: :ok}
    end
    # render json: {user: UserSerializer.new(user), meta: {token: token, message: "User registered successfully."}}, status: :ok
  end

  def update
    if @current_user.update!(password: params[:user][:password])
      user = User.find_by(id: @current_user[:id])
      render json: {user: UserSerializer.new(user), message: "User updated successfully."}, status: :ok
    end
  end

  def destroy
    if @current_user.destroy
      render json: {message: "User deleted Successfully."}, status: :ok
    else
      render json: {message: "User not deleted."}, status: :unprocessable_entity
    end
  end

  def login

  end

  def login_user
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
