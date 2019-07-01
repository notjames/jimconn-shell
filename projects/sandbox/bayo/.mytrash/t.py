#!/usr/bin/python3

import json, sys
from pprint import pprint

IN = ""

for line in sys.stdin:
  IN += line

IN  = json.loads(IN)
OUT = {}

for obj in IN:
  app = obj['Application']
  ver = obj['Version']

  print("app is {} and ver is {}".format(app,ver))
  if app in OUT is False:
    print("got here")
    OUT[app] = {}
  else:
    print("uh oh, check: ")
    pprint(OUT)

  pprint(OUT[app])

#  if ver in OUT[app] is False:
#    OUT[app][ver] = {}
#
#  OUT[app][ver][t_request] += obj['Request_Count']
#  OUT[app][ver][t_success] += obj['Success_Count']

#success_rate = t_success / t_request
#print('Success rate: {:2.0%}'.format(success_rate))

#pprint(OUT)