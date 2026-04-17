module V1

  module Users

    class PostsController < ApplicationController

      # TODO: Add Pundit
      # TODO: Add pagination
      def index
        posts = user.posts.order(created_at: :desc)

        render_success PostSerializer.new(posts, include: [:user])
      end

      def show
        render_success PostSerializer.new(post, include: [:user])
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

end
