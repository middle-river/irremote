#!/usr/bin/python3

PERIOD = 1.0 / (8294400.0 / 64)  # Clock / Prescaler

import math
import sys

data = []
for line in sys.stdin:
  d = line.strip().split()
  if data:
    assert len(d) == len(data[0])
  data.append(d)
buf = []
error_max = 0.0
for d in zip(*data):
  values = [int(x, 16) * PERIOD for x in d]
  mean = sum(values) / len(values)
  buf.append('%f' % (mean * 1000000.0))  # microsecond
  for v in values:
    error = v - mean
    error = math.sqrt(error * error)
    error = error / v
    error_max = max(error_max, error)
print('Error: %.1f%%' % (100.0 * error_max), file=sys.stderr)
print(' '.join(buf))
