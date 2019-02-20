#!/bin/sh
set -e
RUBYCRITICLIMIT=${RUBYCRITICLIMIT:-"90.0"}
QUICK=${QUICK:-}

bundle exec rspec
bundle exec rubocop
if [ -z "$QUICK" ]; then
  gem install bundler-audit && bundle-audit update && bundle-audit check
  bundle exec rake rubycritic lib ${RUBYCRITICPARAMS}
  # only move to the gh-pages if not a PR or branch is master
  if [ "$TRAVIS_PULL_REQUEST" = "false" ] || [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Pushing badges upstream"
    [ -d badges ] || mkdir badges
    cp coverage/coverage_badge* badges/ 2>/dev/null || true
  fi

fi
