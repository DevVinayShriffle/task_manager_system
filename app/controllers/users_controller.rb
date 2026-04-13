class UsersController < ApplicationController
  before_action :authorize_request, except: [ :create, :login , :omniauth]

  def create
    user = User.create!(user_params)
    token = set_token(user)
    respond_to do |format|
      format.html { redirect_to users_tasks_path, notice: "User registered successfully." }
      format.json { render json: { user: UserSerializer.new(user), meta: { token: token, message: "User registered successfully." } }, status: :ok }
    end
  end

  def edit
  end

  def update
    if @current_user.update!(password: params[:user][:password])
      respond_to do |format|
        format.html { redirect_to users_tasks_path, notice: "Password updated." }
        format.json { render json: { message: "User updated successfully." }, status: :ok }
      end
    end
  end

  def destroy
    if @current_user.destroy
      session.delete(:token)
      respond_to do |format|
        format.html { redirect_to root_path, notice: "User deleted Successfully." }
        format.json { render json: { message: "User deleted Successfully." }, status: :ok }
      end
    end
  end

  def login
    return if request.get?
    binding.pry
    user = User.find_by(email: params[:user][:email].strip.downcase)

    if user && user.authenticate(params[:user][:password])
      token = set_token(user)
      respond_to do |format|
        format.html { redirect_to users_tasks_path, notice: "Logged in successfully." }
        format.json { render json: { user: UserSerializer.new(user), meta: { token: token, message: "Logged in successfully." } }, status: :ok }
      end
    else
      flash[:error] = "Invalid email or password."
      respond_to do |format|
        format.html { redirect_to root_path(form: "login") }
        format.json { render json: { message: "Invalid email or password." }, status: :unauthorized }
      end
    end
  end

  def logout
    session.delete(:token)
    respond_to do |format|
      format.html { redirect_to root_path(form: "login"), notice: "Logged out successfully." }
      format.json { render json: { message: "Logged out successfully." }, status: :ok }
    end
  end

  def omniauth
    auth = request.env['omniauth.auth']
    email = auth['info']['email']

    user = User.find_by(email: email)
    flow = request.env['omniauth.params']['flow']

    # signup
    if(flow == 'signup')
      if user
        return redirect_to root_path(form: "login"), notice: 'User already exist. Please, Login.'
      end

      user = User.create!(email: email, password: generate_valid_password)

      token = set_token(user)
      return redirect_to users_tasks_path, notice: 'User Registered Successfully.'
    end

    # login
    if(flow == 'login')
      if user
        token = set_token(user)
        return redirect_to users_tasks_path, notice: 'User Logged in successfully.'
      end

      redirect_to root_path, notice: 'User not found. Please, signup.' 
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_token(user)
    token = JsonWebToken.encode(user_id: user.id)
    token = "Bearer #{token}"
    response.headers["Authorization"] = token
    session[:token] = token
    token
  end

  def generate_valid_password
    # 1. Define character sets
    uppercase = ('A'..'Z').to_a
    lowercase = ('a'..'z').to_a
    digits    = ('0'..'9').to_a
    specials  = %w[@ # $ % & * ! ?] # Add more as needed
    
    # 2. Start with one of each required character to guarantee validity
    password_chars = [
      uppercase.sample,
      lowercase.sample,
      digits.sample,
      specials.sample
    ]

    # 3. Fill the remaining length (total must be 6 to 8)
    # Since we already have 4 chars, we need 2 to 4 more.
    remaining_length = rand(2..4)
    pool = uppercase + lowercase + digits + specials
    
    remaining_length.times { password_chars << pool.sample }

    # 4. Shuffle to ensure mandatory characters aren't always at the start
    password_chars.shuffle.join
  end
end
