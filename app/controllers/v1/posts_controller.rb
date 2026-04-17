module V1

  class PostsController < ApplicationController

    def create
      post = current_user.posts.build(post_params)

      if post.save
        render_success PostSerializer.new(post, include: [:user]), status: :created
      else
        render_errors post.errors
      end
    end

    def destroy
      post.destroy

      head :no_content
    end

    private

    def post
      @post ||= current_user.posts.find(params[:id])
    end

    def post_params
      params.expect(post: %i[content])
    end

  end

end
