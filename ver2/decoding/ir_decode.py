#!/usr/bin/python3

PERIOD = 1.0 / (8294400.0 / 64)  # Clock / Prescaler

import sys

data = []
for line in sys.stdin:
  d = line.strip().split()
  if data:
    assert len(d) == len(data[0])
  d = [int(x, 16) * PERIOD for x in d]
  data.append(d)
result = []
for d in zip(*data):
  mean = sum(d) / len(d)
  result.append(mean)
for i, values in enumerate(data):
  error = max([abs(p - q) / q for p, q in zip(values, result)])
  print('ERROR(%d)=%.1f%%' % (i + 1, error * 100.0), file=sys.stderr)
print(' '.join(['%f' % (value * 1000000.0) for value in result]))  # microsecond
