#!/bin/bash

set -x

/usr/bin/closeApps.py &
while pgrep soffice > /dev/null; do sleep 1; done
