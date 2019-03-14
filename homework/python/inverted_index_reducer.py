#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from collections import defaultdict

inverted_index = defaultdict(set)

def reduce(kv):
  word, filename = kv.split('\t')
  inverted_index[word].add(filename.strip())

if __name__ == "__main__":
  for kv in sys.stdin:
    reduce(kv)

  for word, filename in inverted_index.items():
    print('{0}\t{1}'.format(word, filename))
