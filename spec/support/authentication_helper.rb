module AuthenticationHelper

  def authorization_token(user = nil)
    user ||= create(:user)
    "Bearer #{user.generate_jwt_token}"
  end

  def invalid_authorization_token
    "Bearer invalid_token"
  end

end