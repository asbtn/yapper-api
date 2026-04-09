source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.2"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.22"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

# Serializer
gem "jsonapi-serializer", "~> 2.2"

# JWT
gem "jwt", "~> 3.1"

# CORS
gem "rack-cors", "~> 3.0"

# Service objects interface
gem "simple_command", "~> 1.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Annotating models
  gem "annotaterb", "~> 4.22", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Rubocop linter
  gem "rubocop", "~> 1.84", require: false
  gem "rubocop-rails", "~> 2.34", require: false
  gem "rubocop-rspec", "~> 3.9", require: false
  gem "rubocop-rspec_rails", "~> 2.32", require: false

  # Rspec
  gem "rspec-rails", "~> 8.0.4"

  # Swagger
  gem "rswag", "~> 2.17"

  # Test data
  gem "factory_bot_rails", "~> 6.5"
  gem "faker", "~> 3.6"

  # One-liners
  gem "shoulda-matchers", "~> 7.0"
end
