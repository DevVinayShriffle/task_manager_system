class UsersController < ApplicationController
  before_action :authorize_request, :authorize_user, except: [:create, :login]

  def create
    user = User.create!(user_params)
    set_token(user)
    # render json: user, serializer: UserSerializer, status: :created
    # render json:{
    #   message: "User Registered Successfully.",
    #   user: user,serializer: UserSerializer
    # }, status: ok
    render_with_serializer(user, UserSerializer, "User Created Successfully.", :created)
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.update!(password: params[:user][:password])
    render json: {message: "User updated successfully."}, status: :ok
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: {message: "User deleted Successfully."}, status: :ok
  end

  def login
    user = User.find_by(email: params[:user][:email].strip.downcase)
   
    if(user && user.authenticate(params[:user][:password]))
      set_token(user)
      
      render json: {
        message: "Logged in successfully",
        user: ActiveModelSerializers::SerializableResource.new(
          user,
          serializer: UserSerializer
        )
      }, status: :ok
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
      
    response.headers['Authorization'] = "Bearer #{token}"
  end
end
