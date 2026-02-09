class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :parameter_missing
  rescue_from NoMethodError, with: :no_method_error
  rescue_from ArgumentError, with: :enum_argument_error

  # rescue_from StandardError, with: :internal_server_error

  def authorize_request
    header = request.headers['Authorization']&.split(' ')&.last || session[:token]&.split(' ')&.last
    if header.present?
      begin
        decoded_present(header)
        @current_user = User.find(@decoded[:user_id]) if (@decoded.present?)
      rescue ActiveRecord::RecordNotFound => e
        render json: {errors: e.message}, status: :unauthorized
      end
    else
      render json: {message: "Missing token.", status: :unauthorized}, status: :unauthorized
    end
  end

  def decoded_present(header)
    @decoded = JsonWebToken.decode(header)
    if @decoded.blank?
      render json: {message: "Token invalid."},status: :unauthorized
    elsif Time.current > @decoded[:exp]
      render json: {message: "Token expired."}, status: :unauthorized
    end 
  end

  private

  def record_not_found(error)
    render json: {
      status: 404,
      error: "Record Not Found",
      message: error.message
    }, status: :not_found
  end

  def record_invalid(error)
    flash[:error] = error
    redirect_to request.referrer

    # render json: {
    #   status: 422,
    #   error: "Validation Failed",
    #   message: error.record.errors.full_messages
    # }, status: :unprocessable_entity
  end

  def parameter_missing(error)
    render json: {
      status: 400,
      error: "Bad Request",
      message: error.message
    }, status: :bad_request
  end

  def no_method_error(error)
    render json: {
      status: 500,
      error: "Internal Server Error",
      message: error.message
    }, status: :internal_server_error
  end

  def internal_server_error(error)
    render json: {
      status: 500,
      error: "Internal Server Error",
      message: "Something went wrong"
    }, status: :internal_server_error
  end

  def enum_argument_error(error)
    if error.message.include?("is not a valid status")
      render json: {
        status: 422,
        error: "Validation error",
        message: error.message
      }, status: :unprocessable_entity
    else
      raise error
    end
  end
end
