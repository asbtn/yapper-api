module V1

  class SessionsController < ApplicationController

    allow_unauthenticated_access only: :create

    def create
      service = Sessions::Create.call(params)

      if service.success?
        render_success SessionSerializer.new(**service.result), status: :created
      else
        render_error(status: :unauthorized)
      end
    end

  end

end
