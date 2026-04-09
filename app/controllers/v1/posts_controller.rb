module V1

  class PostsController < ApplicationController

    # TODO: Add Pundit
    # TODO: Add pagination
    def index
      posts = user.posts.order(created_at: :desc)

      render_success PostSerializer.new(posts)
    end

    def show
      render_success PostSerializer.new(post)
    end

    def create
      service = Posts::Create.call(user, post_params)

      if service.success?
        render_success PostSerializer.new(service.result), status: :created
      else
        render_errors service.errors
      end
    end

    def destroy
      post.destroy

      head :no_content
    end

    private

    def user
      @user ||= User.find(params[:user_id])
    end

    def post
      @post ||= user.posts.find(params[:id])
    end

    def post_params
      params.expect(post: %i[content])
    end

  end

end
