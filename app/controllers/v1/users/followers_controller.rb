module V1

  module Users

    class FollowersController < ApplicationController

      # TODO: Add Pundit
      # TODO: Add pagination
      def index
        render_success PublicUserSerializer.new(user.followers.order(:id))
      end

      private

      def user
        @user ||= User.find(params[:user_id])
      end

    end

  end

end
