#!/bin/bash

#  ci_post_clone.sh
#  breadwallet
#
#  Created by Gardner von Holt on 9/6/22.
#  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.

# Set the -e flag to stop running the script in case a command returns
# a nonzero exit code.
set -e

# Install SwiftLint to run lint checks
brew install SwiftLint

# Create the .env file
cd /Volumes/workspace/repository/brd-ios

BRD_ENV=.env
touch $BRD_ENV

# The environment variables go here
echo "BREAD_TOKEN=$BREAD_TOKEN" >> $BRD_ENV
echo "STAGING_URL=$STAGING_URL" >> $BRD_ENV
echo "STAGING_TOKEN=$STAGING_TOKEN" >> $BRD_ENV
echo "STAGING_CHECKOUT_TOKEN=$STAGING_CHECKOUT_TOKEN" >> $BRD_ENV
echo "" >> $BRD_ENV

# display the script
cat << $BRD_ENV

# Setting the marketing build
agvtool new-marketing-version $MARKETING_VERSION
