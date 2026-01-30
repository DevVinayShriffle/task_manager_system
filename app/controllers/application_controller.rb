class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from  ActiveRecord::RecordNotUnique, with: :record_not_unique

  def authorize_request
    header = get_header
    if header.present?
      begin
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {errors: e.message}, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: {errors: e.message}, status: :unauthorized
      end
    else
      render json: {message: "Missing token.", status: :unauthorized}, status: :unauthorized
    end
  end

  def get_header
    header = request.headers['Authorization']&.split(' ')&.last
  end

  def authorize_user    
    render json: {message: "You are not authorize for this action."}, status: :unauthorized if (@current_user.id != params[:id].to_i)
  end

  def render_with_serializer(object, serializer, message, status)
    render json: {
      message: message,
      user: ActiveModelSerializers::SerializableResource.new(object, serializer: serializer)
    }, status: status
  end

  private

  def record_not_found(error)
    render json: {
      error: error.message
    }, status: :not_found
  end

  def record_invalid(error)
    render json: {
      error: error.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def parameter_missing(error)
    render json: {
      error: error.message
    }, status: :bad_request
  end

  def record_not_unique(error)
    render json: {
      error: error.message
    }, status: :internal_server_error
  end

  def unauthorized
    render json: {
      error: "Unauthorized access."
    }, status: :unauthorized
  end

end
