#!/bin/bash

cd /home/ec2-user/kthr01/ && touch cd_test_`date +%Y%m%d_%H%M`.txt
#cd /home/ec2-user/kthr01/ && git pull && bundle install --path vendor/bundle --without test development && bundle exec rails assets:precompile RAILS_ENV=production
