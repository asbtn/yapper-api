module V1

  module Users

    class PostsController < ApplicationController

      def index
        scope = user.posts.order(created_at: :desc, id: :desc)

        @pagy, posts = pagy(:keyset, scope, limit: limit)

        render_success PostSerializer.new(posts,
                                          include: [:user],
                                          meta: { next: @pagy.next })
      end

      def show
        render_success PostSerializer.new(post, include: [:user])
      end

      private

      def user
        @user ||= User.find_by_identifier(params[:user_id])
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
