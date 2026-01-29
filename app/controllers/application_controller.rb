class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  # stale_when_importmap_changes

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from  ActiveRecord::RecordNotUnique, with: :record_not_unique

  def not_found
    render json: {error: not_found}
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {errors: e.message}, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: {errors: e.message}, status: :unauthorized
    end
  end

  def authorize_user
    if (@current_user.id != params[:id].to_i)
      render json: {message: "You are not authorize for this action."}, status: :unauthorized
    end
  end

  # def authorize_user_tasks
  #   if (@current_user.id != params[:user_id].to_i)
  #     render json: {message: "You are not authorize for this action."}, status: :unauthorized
  #   end
  # end

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
