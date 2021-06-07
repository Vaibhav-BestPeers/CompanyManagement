class Api::V1::ApiController < ApplicationController
    skip_before_action :authenticate_user!
    protect_from_forgery :only => [:create, :update, :destroy]


    # before_action :current_user
    # def current_user
    #  user =  User.find_by(id: request.headers["Authorization"])
    #  unless user
    #   render json: :unauthorized,status: 403
    #  end
    #  return user
    # end
end
