class SessionSerializer

  def initialize(user:, token:)
    @user = user
    @token = token
  end

  def serializable_hash
    {
      data: {
        token: token,
        user: PrivateUserSerializer.new(user).serializable_hash[:data]
      }
    }
  end

  private

  attr_reader :user, :token

end
