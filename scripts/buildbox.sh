#!/bin/bash
set -e

echo '--- setting ruby version 2.1'
rbenv install 2.1.10
rbenv local 2.1.10

echo '--- bundling activesupport 4.2'
ACTIVESUPPORT_VERSION="~> 4.0.0" bundle install -j $(nproc) --without production

echo '--- running specs activesupport 4.2'
REVISION=https://github.com/$BUILDBOX_PROJECT_SLUG/commit/$BUILDBOX_COMMIT
if bundle exec rspec; then
  echo "[Successful] $BUILDBOX_PROJECT_SLUG - Build - $BUILDBOX_BUILD_URL - Commit - $REVISION"
else
  echo "[Failed] Build $BUILDBOX_PROJECT_SLUG - Build 4.2 - $BUILDBOX_BUILD_URL - Commit - $REVISION" | hipchat_room_message -t $HIPCHAT_TOKEN -r $HIPCHAT_ROOM -f "Buildbox" -c "red"
  exit 1;
fi

echo '--- setting ruby version 2.3'
rbenv install 2.3.4
rbenv local 2.3.4

echo '--- bundling activesupport 5.0'
ACTIVESUPPORT_VERSION="~> 5.0.0" bundle update

echo '--- running specs activesupport 5.0'
REVISION=https://github.com/$BUILDBOX_PROJECT_SLUG/commit/$BUILDBOX_COMMIT
if bundle exec rspec; then
  echo "[Successful] $BUILDBOX_PROJECT_SLUG - Build - $BUILDBOX_BUILD_URL - Commit - $REVISION"
else
  echo "[Failed] Build $BUILDBOX_PROJECT_SLUG - Build 5.0 - $BUILDBOX_BUILD_URL - Commit - $REVISION" | hipchat_room_message -t $HIPCHAT_TOKEN -r $HIPCHAT_ROOM -f "Buildbox" -c "red"
  exit 1;
fi

echo '--- setting ruby version 2.4'
rbenv install 2.4.1
rbenv local 2.4.1

echo '--- bundling activesupport 5.1'
ACTIVESUPPORT_VERSION="~> 5.1.0" bundle update

echo '--- running specs activesupport 5.1'
REVISION=https://github.com/$BUILDBOX_PROJECT_SLUG/commit/$BUILDBOX_COMMIT
if bundle exec rspec; then
  echo "[Successful] $BUILDBOX_PROJECT_SLUG - Build - $BUILDBOX_BUILD_URL - Commit - $REVISION" | hipchat_room_message -t $HIPCHAT_TOKEN -r $HIPCHAT_ROOM -f "Buildbox" -c "green"
else
  echo "[Failed] Build $BUILDBOX_PROJECT_SLUG - Build 5.1 - $BUILDBOX_BUILD_URL - Commit - $REVISION" | hipchat_room_message -t $HIPCHAT_TOKEN -r $HIPCHAT_ROOM -f "Buildbox" -c "red"
  exit 1;
fi