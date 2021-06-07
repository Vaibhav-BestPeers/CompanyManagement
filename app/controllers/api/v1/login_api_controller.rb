class Api::V1::LoginApiController < Api::V1::ApiController
  require 'securerandom'
  before_action :load_user, only: :create

  def create
    @user =  User.find_by(email: request.headers["email"])
    if @user.valid_password?(request.headers["password"])
      
      custom_token = SecureRandom.hex
      @user.update(custom_authentication_token: custom_token)
      sign_in "user", @user
      render json: {
        messages: "Signed In Successfully",
        is_success: true,
        data: {user: @user, token: custom_token }
      }, status: :ok
    else
      render json: {
        messages: "Signed In Failed - Unauthorized",
        is_success: false,
        data: {}
      }, status: :unauthorized
    end
  end


  private

  def load_user
    @user =  User.find_by(email: request.headers["email"])
    if @user
      return @user
    else
      render json: {
        messages: "Invalid Email entered",
        is_success: false,
        data: {}
      }, status: :not_found
    end
  end

end
