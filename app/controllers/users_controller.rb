class UsersController < ApplicationController
  before_action :authorize_request, except: [:create, :login]

  def create
    user = User.create!(user_params)
    token = set_token(user)
    # render json: {user: UserSerializer.new(user), meta: {token: token, message: "User registered successfully."}}, status: :ok
    respond_to do |format|
      format.html { redirect_to users_tasks_path, notice: "User registered successfully." }
      format.json { render json: {user: UserSerializer.new(user), meta: {token: token}}, status: :ok }
    end
  end

  def edit
  end

  def update
    if @current_user.update!(password: params[:user][:password])
      # user = User.find_by(id: @current_user[:id])
      # render json: {user: UserSerializer.new(user), message: "User updated successfully."}, status: :ok
      respond_to do |format|
        format.html { redirect_to users_tasks_path, notice: "Password updated." }
        format.json { render json: {message: "User updated successfully."}, status: :ok }
      end
    end
  end

  def destroy
    if @current_user.destroy
      # render json: {message: "User deleted Successfully."}, status: :ok
      respond_to do |format|
        format.html { redirect_to root_path, notice: "User deleted." }
        format.json { render json: {message: "User deleted Successfully."}, status: :ok }
      end
     # else
      # render json: {message: "User not deleted."}, status: :unprocessable_entity
    end
  end

  def login
    return if request.get?
    user = User.find_by(email: params[:user][:email].strip.downcase)
   
    if(user && user.authenticate(params[:user][:password]))
      token = set_token(user)
      redirect_to users_tasks_path
      # render json: {user: UserSerializer.new(user), meta: {token: token, message: "Logged in successfully."} }, status: :ok
      # respond_to do |format|
        # format.html { redirect_to users_tasks_path, notice: "Logged in successfully." }
        # format.json { render json: {user: UserSerializer.new(user), meta: {token: token}}, status: :ok }
      # end
    else
      # render json: {message: "Invalid email or password."}
      respond_to do |format|
        # format.html { render :login }
        # format.json { render json: {message: "Invalid email or password."} }
        flash[:alert] = "Invalid email or password"
        redirect_to login_users_path
      end
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
    session[:token] = token
    token
  end
end
