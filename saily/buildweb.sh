#!/bin/bash

DATE=$(date +%Y-%m-%d:%H:%M:%S)
GITVERSION=$(git describe --always)
GITBRANCH=$(git branch --show-current) 

flutter build web --release --dart-define=PLATFORM=web --dart-define=DATE=$DATE --dart-define=GITVERSION=$GITVERSION --dart-define=GITBRANCH=$GITBRANCH