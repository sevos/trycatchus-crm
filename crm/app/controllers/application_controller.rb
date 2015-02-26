class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :authenticate!
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from CanCan::AccessDenied, with: :render_forbidden
  check_authorization

  private

  def render_not_found
    render nothing: true, status: :not_found
  end

  def render_validation_errors(model)
    render json: {model.class.name.underscore => model.errors},
           status: :unprocessable_entity
  end

  def render_unauthorized
    render nothing: true, status: :unauthorized
  end

  def render_forbidden
    render nothing: true, status: :forbidden
  end

  attr_reader :current_user

  def authenticate!
    @current_user = Guest.new
    authenticate_with_http_basic do |user_name, password|
      user = User.find_by(name: user_name)
      if user && user.authenticate(password)
        @current_user = user
      else
        render_unauthorized
      end
    end
  end
end
