```
# redis
docker compose up -d

# web
bundle install
bin/rails s
open localhost:4000

# job
bundle exec sidekiq -C config/sidekiq_chat.yml
```
