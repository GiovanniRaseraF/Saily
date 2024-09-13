#!/bin/bash

DATE=$(date +%Y-%m-%d:%H:%M:%S)
GITVERSION=$(git describe --always)
GITBRANCH=$(git branch --show-current) 

flutter build web --release --web-renderer html --no-web-resources-cdn --dart-define=PLATFORM=web --dart-define=DATE=$DATE --dart-define=GITVERSION=$GITVERSION --dart-define=GITBRANCH=$GITBRANCH