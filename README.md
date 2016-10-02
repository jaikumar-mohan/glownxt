## Glowfori Tweets

This application is the start of the online glowfori offering
[*glowfori*](http://www.glowfori.com/)


## Markdown syntax to edit this file

* http://daringfireball.net/projects/markdown/syntax



# Conception

## Sign Up Workflow

Controller::action :

1. Users:new
1. EmailValidation::edit
1. Users::pitching
1. Company::update_pitch
1. Company::edit


# Technical


## Environment Setup

* `rake db:migrate` produces an error on the first time, but
* `rake db:reset` seems to work
* `rake db:populate` create fake data (users, microposts, companies...)
** Once done they can use example-N@glowfori.com (with 0 < N < 20) as login and "password" as password (see `sample_data.rake`).


## Tests

Two test frameworks ares used.

* rspec (sources are in 'spec')
* cucumber (sources are in 'features')

Can be executed in a terminal, from the project root, with command having the same name ('rspec' or 'cucumber').

Launch 'guard' while developing (see 'Guard' part below).


### RSpec

* Sources are in 'spec'.
* 'rspec' to execute all specs.


### Cucumber

* Sources are in 'features'.
* 'cucumber' to execute all features.


### spork

* DRb server to "cache" environment (loaded only one time)
* Launch 'spork' in a separate terminal from the project root (before launching tests)


### guard

* Watchdog that survey the filesystem and execute a Guard module on event
* In our case launch failed tests (when a source code is modified)
* Launch 'guard' in a terminal from the project root (no need to launch 'spork' before)


### Notifications

* rspec-nc is a RSpec formatter for Mountain Lion's Notification Center (https://github.com/twe4ked/rspec-nc)
* cucumber-nc is a Cucumber formatter for Mountain Lion's Notification Center (https://github.com/twe4ked/rspec-nc)

When we launch 'rspec', 'cucumber' or 'guard' commands, Mountain Lion's Notification will be displayed at the end.
