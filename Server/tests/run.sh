#!/bin/bash

#export NODE_TLS_REJECT_UNAUTHORIZED='0' # on linux
#set NODE_TLS_REJECT_UNAUTHORIZED=0 #on windows

node test_ping.js
node test_fetchmyboats.js
node test_fetch_emi.js
node test_fetch_acti.js
node test_fetch_endoi.js
node test_fetch_hpbi.js
node test_fetch_gi.js
node test_fetch_nmea2000.js
node test_fetch_vi.js
