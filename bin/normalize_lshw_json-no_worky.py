#!/usr/bin/python

from pprint import pprint
import json

# need the following: version, id, class, description, product, 
# vendor, businfo, slot, logical name physid, serial, capacity, 
# clock, size, and units

def whittle_keys(data):
#  print '2 got here.'
  seek_keys = ['version', 'id', 'class', 'description', 'product', 
               'vendor', 'businfo', 'slot', 'logicalname', 'physid', 
               'serial', 'capacity', 'clock', 'size', 'units']
  wanted    = {}

  if isinstance(data,dict):
    for key in data.keys():
      try:
        if key in seek_keys:
          try:
            wanted[key] = data[key]
          except:
            wanted[key] = ''
      except:
        pass
  else:
    return None

  return wanted

def process_child_block(data):
  is_wanted = {}

  if data.has_key('children'):
    for child_block in data['children']:
      if child_block.has_key('class'):
        # initialize is_wanted as an array
        try:
          is_wanted[data['class']]
        except:
          is_wanted[data['class']] = []

        something = whittle_keys(child_block)

        if something is not None:
          is_wanted[data['class']].append(something)

  return is_wanted

def process_block(data):
  is_wanted = {}
  meta_data = {}

  try:
    if data.has_key['class']:
      meta_data = whittle_keys(data)
      is_wanted[data['class']].append({meta_data,process_child_block(data)})
  except:
    pass

  return is_wanted

def process_json(data):
# extract data for the system object (at root of data tree)
  received = whittle_keys(data)

  # entry point into the rest of the system is data['children']
  received['system'] = process_block(data['children'])

  return received

# extracted and whittled
e_and_w = {}

with open('HNLT482-20160321.json') as json_data:
    data = json.load(json_data)

e_and_w['machine']  = process_json(data)

#print ': {}'.format(e_and_w)
