module V1

  module Users

    class FollowingsController < ApplicationController

      # TODO: Add Pundit

      def index
        scope = user.following.order(id: :desc)
        @pagy, followings = pagy(:keyset, scope, limit: limit)

        render_success PublicUserSerializer.new(followings,
                                                meta: { next: @pagy.next })
      end

      private

      def user
        @user ||= User.find(params[:user_id])
      end

    end

  end

end
