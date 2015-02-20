class Api::V1::ApiController < ActionController::Base
# Authentication and other filters implementation.

  def authenticate
    token = request.headers["token"]
    name = request.headers["name"]
    Rails.logger.info "Token : " + token
    Rails.logger.info "Name : " + name
    @user = User.where(name: name).first
    @user.api_key.token == token 
    
  end

end