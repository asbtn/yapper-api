module Posts

  class Create

    prepend SimpleCommand

    def initialize(user, params)
      @user   = user
      @params = params
    end

    def call
      return post if post.valid? && post.save!

      errors.merge!(post.errors)
      nil
    end

    private

    attr_reader :user, :params

    def post
      @post ||= user.posts.build(params)
    end

  end

end
