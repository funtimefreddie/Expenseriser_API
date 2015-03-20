class ApiKey < ActiveRecord::Base
  belongs_to :user
  before_create :generate_token

  private

  #generates random 30 digit token
  def generate_token
    begin
      self.token = SecureRandom.hex.to_s
    end while self.class.exists?(token: token)
  end
  
end
