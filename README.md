# Web crawler

A demo CLI application that communicates with Coolpay api

## Getting Started

These instructions will get you a copy of the project up and running on your local machine 
for development and testing purposes.

### Installing

Project uses Ruby 2.5.1

Install Ruby and Bundler
```
rvm install $(cat .ruby-version )
gem install bundler
```

Install all dependencies

```
bundle install
```

That's it, now it's all set up!

### Usage

```bash
bin/coolpay
```

This produces following a help screen that guides you on how to use the tool

The only implemented action is login:
```bash
bin/coolpay --username=your_user_name --apikey=your_api_key
```

## Running the tests

```bash
bundle exec rspec
```

### And coding style tests

```
bundle exec rubocop
```

## Deployment

This is a demo project which is meant to be ran locally

## TODO

* figure out the best way to tests for bin/coolpay
* extract login action from lib/coolpay.rb
* implement more actions like creating recipients, payments
* figure out how to solve Metrics/MethodLength in lib/coolpay.rb