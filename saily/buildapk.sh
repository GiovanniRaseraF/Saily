#!/bin/bash

DATE=$(date +%Y-%m-%d:%H:%M:%S)
GITVERSION=$(git describe --always)
GITBRANCH=$(git branch --show-current) 

flutter build apk --release --dart-define=PLATFORM=android --dart-define=DATE=$DATE --dart-define=GITVERSION=$GITVERSION --dart-define=GITBRANCH=$GITBRANCH