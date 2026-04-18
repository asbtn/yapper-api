module V1

  class TimelinesController < ApplicationController

    def show
      scope = Post.timeline_for(current_user)
      @pagy, posts = pagy(:keyset, scope, limit: limit)

      render_success PostSerializer.new(posts,
                                        include: [:user],
                                        meta: { next: @pagy.next })
    end

  end

end
