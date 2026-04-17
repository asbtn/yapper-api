module V1

  class TimelinesController < ApplicationController

    def show
      posts = Post.timeline_for(current_user)

      render_success PostSerializer.new(posts, include: [:user]), status: :ok
    end

  end

end
