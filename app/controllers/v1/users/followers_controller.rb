module V1

  module Users

    class FollowersController < ApplicationController

      def index
        scope = user.followers.order(id: :desc)
        @pagy, followers = pagy(:keyset, scope, limit: limit)

        render_success PublicUserSerializer.new(followers,
                                                meta: { next: @pagy.next })
      end

      private

      def user
        @user ||= User.find_by_identifier(params[:user_id])
      end

    end

  end

end
