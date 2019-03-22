#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import re
import os

def map(input):
  filename = os.path.basename(os.environ["map_input_file"]) 
  words = re.split('[\s,.]', input)
  return [(word, filename) for word in words if word]

def pipe(kv):
  for word, filename in kv:
    print('{0}\t{1}'.format(word,filename))

if __name__ == "__main__":
  for input in sys.stdin:
    kv = map(input)
    pipe(kv)
