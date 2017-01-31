#!/bin/bash

# readme file
README='README.md'

# output dir
SCRIPT_OUTPUT='coverage_output'
mkdir -p $SCRIPT_OUTPUT

# run test
echo "Running test"
xcodebuild \
    -workspace ./Example/IndigoOmtIosLibrary.xcworkspace \
    -scheme "IndigoOmtIosLibrary-Example" \
    test \
    -destination "platform=iOS Simulator,name=iPhone 5" \
    &> "./$SCRIPT_OUTPUT/xcodebuild.log"

# generate coverage
echo "Generating coverage"
xcov \
    -w ./Example/IndigoOmtIosLibrary.xcworkspace \
    -s IndigoOmtIosLibrary \
    -o "./$SCRIPT_OUTPUT" \
    --exclude_targets Quick.framework,Alamofire.framework,Nimble.framework,AppAuth.framework,SwiftyJSON.framework,IndigoOmtIosLibrary_Example.app \
    --html_report \
    --markdown_report \
    &> "./$SCRIPT_OUTPUT/xcov.log"

# update readme
echo "Updating readme"

# remove previous coverage results from README
sed -i.bak '/## Current coverage for/,$ d' "./$README"
rm "./$README.bak"

# append new coverage results
cat "./$SCRIPT_OUTPUT/report.md" >> "./$README"

# show report
echo "Opening report"
open "./$SCRIPT_OUTPUT/index.html"
