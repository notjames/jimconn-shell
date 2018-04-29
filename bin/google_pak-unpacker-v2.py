#!/usr/bin/python

import collections
import struct
import sys
def ReadFile(filename, encoding):
  mode = 'rb' if encoding == 0 else 'rU'
  with open(filename, mode) as f:
    data = f.read()
  if encoding not in (0, 1):
    data = data.decode(encoding)
  return data

PACK_FILE_VERSION = 4
HEADER_LENGTH = 2 * 4 + 1  # Two uint32s. (file version, number of entries) and
                           # one uint8 (encoding of text resources)
def UnpackDataPack(input_file):
  """Reads a data pack file and returns a dictionary."""
  data = ReadFile(input_file, 0)
  original_data = data

  # Read the header.
  version, num_entries, encoding = struct.unpack("<IIB", data[:HEADER_LENGTH])
  if version != PACK_FILE_VERSION:
    print "Wrong file version in ", input_file
    raise WrongFileVersion

  resources = {}
  if num_entries == 0:
    return DataPackContents(resources, encoding)

  # Read the index and data.
  data = data[HEADER_LENGTH:]
  kIndexEntrySize = 2 + 4  # Each entry is a uint16 and a uint32.
  for _ in range(num_entries):
    id, offset = struct.unpack("<HI", data[:kIndexEntrySize])
    data = data[kIndexEntrySize:]
    next_id, next_offset = struct.unpack("<HI", data[:kIndexEntrySize])
    resources[id] = original_data[offset:next_offset]
    filetype = 'bin'
    fileheader = ''.join(original_data[offset:offset+1])
    print ord(fileheader[0])
    if fileheader == '<':
      filetype = 'html'
    if fileheader == '\x89':
      filetype = 'png'
    elif fileheader == '/':
      filetype = 'js'
    of = open('{0}.{1}'.format(id,filetype),'wb')
    of.write(original_data[offset:next_offset])
    of.close()
def main():
  if len(sys.argv) > 1:
    UnpackDataPack(sys.argv[1])


if __name__ == '__main__':
  main()
