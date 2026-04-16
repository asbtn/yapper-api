module V1

  class UsersController < ApplicationController

    allow_unauthenticated_access only: :create

    def show
      render_success PublicUserSerializer.new(
        user,
        meta: {
          followed_by_current_user: Follow.exists?(follower: current_user, following: user),
          follows_current_user: Follow.exists?(follower: user, following: current_user)
        }
      )
    end

    def create
      service = ::Users::Create.call(user_params)

      if service.success?
        render_success PrivateUserSerializer.new(service.result), status: :created
      else
        render_errors service.errors
      end
    end

    private

    def user
      @user ||= User.find(params[:id])
    end

    def user_params
      params.expect(user: %i[handle username bio email_address password password_confirmation])
    end

  end

end
