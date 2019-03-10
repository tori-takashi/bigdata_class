###################################################
# create inverted index from designated directory #
###################################################

import sys
import re
import Path
import os
from collections import defaultdict

class InvertedIndexMapper:

  def purify(self, line):
    words = re.split(r'\s', line)
    return [(key, os.environ["map_input_file"]) for key in words if key]

  def map_output(kv):
    for k, v in kv:
      print('{0}\t{1}'.format(k,v))

  def map(self):
    for line in sys.stdin:
      kv = purify(line)
      map_output(kv)

class InvertedIndexReducer:

  inverted_index = defaultdict(list)

  def reduce(self):
    k, v = line.split('\t')
    inverted_index[key].append(v)

if __name__ == "__main__":
  mode = ARGV[1]

  if mode == "map":
    mapper = InvertedIndexMapper()
    mapper.map()

  elif mode == "reduce":
    reducer = InvertedIndexReducer()
    reducer.reduce()
