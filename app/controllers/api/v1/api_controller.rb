class Api::V1::ApiController < ActionController::Base
# Authentication and other filters implementation.

  # # returns boolean - true if we can authenticate
  # def authenticate
  #   # receive token and name
  #   token = request.headers["token"]
  #   name = request.headers["name"]

  #   # add to logger
  #   Rails.logger.info "Token : " + token
  #   Rails.logger.info "Name : " + name

  #   # search user and compare stored token to received token
  #   @user = User.where(name: name).first
  #   @user.api_key.token == token 
    
  # end

end