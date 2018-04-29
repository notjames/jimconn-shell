#!/bin/bash

killall -9 conky 2>/dev/null
/usr/bin/conky -qdy 25
