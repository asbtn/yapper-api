module Users

  class Create

    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      if user.save
        user
      else
        errors.merge!(user.errors)
        nil
      end
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
