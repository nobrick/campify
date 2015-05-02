# Campify
## Installation
### 1. Install PostgreSQL
In OS X, you can install PostgreSQL with [Homebrew](http://brew.sh/):
```
brew install postgres
```
To create the database:
```
initdb /usr/local/var/postgres
```
Then start PostgreSQL server:
```
postgres -D /usr/local/var/postgres
```
### 2. Set database.yml and secret.yml
```
cp config/database.yml.example to config/database.yml.rb
cp config/secret.yml.example to config/secret.yml.rb
```
Remember to *change* passwords and secret tokens in the files above for security reasons.
### 3. Start the server
Before starting the server, you may need to run `bundle install` to install required gems and `rake db:setup` to initialize the database.
```
bin/rails server
```

## Contribution
### Test
```
bin/rake exec guard
```
