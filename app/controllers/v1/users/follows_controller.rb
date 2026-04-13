module V1

  module Users

    class FollowsController < ApplicationController

      # TODO: Add Pundit

      def create
        follow = Follow.new(follower: current_user, following: user)

        if follow.save
          render_success PublicUserSerializer.new(user), status: :created
        else
          render_errors follow.errors
        end
      end

      def destroy
        follow = Follow.find_by!(follower: current_user, following: user)
        follow.destroy

        head :no_content
      end

      private

      def user
        @user ||= User.find(params[:user_id])
      end

    end

  end

end
