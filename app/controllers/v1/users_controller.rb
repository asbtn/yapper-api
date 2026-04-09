module V1

  class UsersController < ApplicationController

    allow_unauthenticated_access only: :create

    def show
      render_success UserSerializer.new(user)
    end

    def create
      service = ::Users::Create.call(user_params)

      if service.success?
        render_success UserSerializer.new(service.result), status: :created
      else
        render_errors service.errors
      end
    end

    private

    def user
      @user ||= if params[:id] == "me"
                  current_user
                else
                  User.find_by_identifier(params[:id])
                end
    end

    def user_params
      params.expect(user: %i[handle username bio email_address password password_confirmation])
    end

  end

end
