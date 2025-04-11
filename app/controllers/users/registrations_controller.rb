class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, only: [:show, :update]

  respond_to :json
  include ActionController::MimeResponds

  skip_before_action :verify_authenticity_token, raise: false

  # 🚫 Prevent Devise from using session-based redirects
  def require_no_authentication
    # override Devise default behavior to avoid session usage
  end

  # 🔍 GET /profile
  def show
    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    render json: serialize_user(current_user)
  end

  # 📝 POST /signup
  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
        render json: serialize_user(resource).merge(token: token), status: :ok
      else
        render json: { error: 'Account not active' }, status: :unauthorized
      end
    else
      Rails.logger.debug "Signup failed: #{resource.errors.full_messages.inspect}"
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✏️ PUT /profile
  def update
    if current_user.update(account_update_params)
      render json: serialize_user(current_user), status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :username, :avatar)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :current_password, :username, :avatar)
  end

  def serialize_user(user)
    {
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
        avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
      }
    }
  end
end
