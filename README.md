Yapper API is the backend for the Yapper project — a lightweight social platform inspired by Twitter, focused on short posts (“yaps”), profiles, and following features.

This app provides the REST API and data layer used by the [Yapper React frontend](https://github.com/asbtn/yapper).

## Setup

```bash
# install dependencies
docker compose up --build
```

## Stack

- Ruby on Rails 8
- PostgreSQL
- JWT-based authentication
- Action Cable (for real-time updates)
- Active Storage (for image uploads)
- RSpec (for testing)
- Sidekiq + Redis (planned for background jobs)

## Features (planned & in progress)

- [x] User signup/login (JWT auth)
- [ ] User profiles (bio, avatar)
- [ ] Create, edit, and delete yaps
- [ ] View and fetch yaps by user
- [ ] Follow/unfollow users
- [ ] Feed with yaps from followed accounts

- [ ] Replies to yaps
- [ ] Likes on yaps
- [ ] Notifications for likes and replies
- [ ] Account settings (email, password change)

- [ ] Private profiles (followers only)
- [ ] Block/unblock users
- [ ] Yaps with image attachments (Active Storage)
- [ ] Search users by name or username
- [ ] Search yaps
- [ ] Real-time updates using Action Cable