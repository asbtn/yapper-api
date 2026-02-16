require "jwt"

module JwtToken

  ALGORITHM = "HS256".freeze
  DEFAULT_EXPIRY = 3.minutes

  def self.encode(payload, expiry: DEFAULT_EXPIRY)
    now = Time.now.to_i
    JWT.encode(
      { data: payload.deep_symbolize_keys, exp: now + expiry.to_i },
      Rails.application.credentials.secret_key_base,
      ALGORITHM
    )
  end

  def self.decode(token)
    JWT.decode(token,
               Rails.application.credentials.secret_key_base,
               true,
               algorithm: JwtToken::ALGORITHM).first
  end

end
