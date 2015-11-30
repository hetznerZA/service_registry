#!/bin/bash
TEST_ORCHESTRATION_PROVIDER=stub bundle exec cucumber features&&TEST_ORCHESTRATION_PROVIDER=tfa bundle exec cucumber features&&bundle exec rspec -cfd spec&&TEST_ORCHESTRATION_PROVIDER=production bundle exec cucumber features
