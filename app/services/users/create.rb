module Users

  class Create

    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    # TODO: Confirmation email
    # TODO: Welcome email
    def call
      return user if user.valid? && user.save!

      errors.merge!(user.errors)
      nil
    end

    private

    attr_reader :params

    def build_user
      @user = User.new(params)
    end

    def user
      @user ||= build_user
    end

  end

end
