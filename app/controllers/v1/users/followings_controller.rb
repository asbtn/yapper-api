module V1

  module Users

    class FollowingsController < ApplicationController

      # TODO: Add Pundit
      # TODO: Add pagination
      def index
        render_success UserSerializer.new(user.following.order(:id))
      end

      private

      def user
        @user ||= User.find(params[:user_id])
      end

    end

  end

end
