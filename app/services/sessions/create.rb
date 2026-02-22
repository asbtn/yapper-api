module Sessions

  class Create

    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      return session if authenticate

      errors.add(:base, "Invalid credentials")
    end

    private

    attr_reader :params

    def user
      return @user if defined?(@user)

      @user = User.find_by(email_address: params[:email_address])
    end

    def authenticate
      user&.authenticate(params[:password])
    end

    def token
      user.generate_jwt_token
    end

    def session
      { user:, token: }
    end

  end

end
