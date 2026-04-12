class SessionSerializer

  def initialize(user:, token:)
    @user = user
    @token = token
  end

  def serializable_hash
    {
      token: token,
      user: UserSerializer.new(user).serializable_hash
    }
  end

  private

  attr_reader :user, :token

end
