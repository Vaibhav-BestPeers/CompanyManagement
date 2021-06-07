class ApplicationController < ActionController::Base
    add_flash_types :success, :warning, :danger, :info, :vaibhav_flash
  

    before_action :authenticate_user!
end
