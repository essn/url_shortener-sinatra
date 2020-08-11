# README
## Overview
Minimalistic Sinatra API to shorten URLs.

## Setting up the app
**Install dependencies**
`bundle`

**Create database**
`be rake db:create`

**Run Test Suite**
`rspec`

**Start server**
`BASE_URL=localhost:4567 ruby app.rb`

*Note*:
`BASE_URL` is a bit hacky and there is likely a better way to do it in Sinatra, 
but if you want to test the app locally via Postman or similar it works.

## Routes
**`POST /short_url`**
-
Creates a short url.

**Parameters:**
`original_url`
`slug` - optional

**`DELETE /short_url/:slug`**
-
Deletes a short url if the secret key matches.

**Parameters:**
`secret_key`

**`GET /:slug`**
-
If the request is coming from a browser, it reroutes to the original url. If the 
request is coming from a client, it returns a serialized short url.

## Considerations
**Framework**
Sinatra over Rails because the scope of the project could be smaller and I did 
not want code bloat. It also allowed me to handle things on a lower level and 
avoid some of the abstraction that "Rails Magic" can provide to better show my 
skillset.

**Database**
SQLite to keep dependencies down and allow it to run without needing to host 
Postgres, MySQL, or similar.

**Dependencies**
One Gem of note is the [Interactor Gem]([https://github.com/collectiveidea/interactor](https://github.com/collectiveidea/interactor)). In hindsight, I could probably have just used PORO 
service objects but was anticipating using the pattern more. I left it in 
anyways because I'm a fan of the pattern and it worked for my one use case.

ActiveRecord is also included. I may be able to leave Rails, but ActiveRecord 
is too good to stray from.

**Improvements**
The biggest hole is that security is pretty light. Had I more time, I would 
using JWT authentication  and some sort of user/client structure or at the 
very least hashed and securely compared the secret tokens.
