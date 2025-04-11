class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    Rails.logger.debug "[🔥DEBUG] Raw params at entry: #{params.to_unsafe_h.inspect}"

    # Flatten the nesting if session key is present
    if params[:session].present? && params[:session][:user]
      Rails.logger.debug "[🐛FIX] Flattening nested session[:user] into params[:user]"
      params[:user] = params[:session][:user]
    end

    super
  end

  private

  def respond_with(resource, _opts = {})
    begin
      avatar_url = resource.avatar.attached? ? url_for(resource.avatar) : nil
    rescue => e
      Rails.logger.error "⚠️ Avatar URL generation failed: #{e.message}"
      avatar_url = nil
    end

    render json: {
      user: {
        id: resource.id,
        email: resource.email,
        username: resource.username,
        avatar_url: avatar_url
      },
      token: request.env['warden-jwt_auth.token']
    }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end
