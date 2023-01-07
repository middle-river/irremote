#!/usr/bin/python3
# Repeatedly merges two similar values (pulse width).

import sys

assert len(sys.argv) == 2, 'usage: %s <clusters>' % sys.argv[0]
num = int(sys.argv[1])

data = sys.stdin.readline().split()
data = [float(d) for d in data]

value2cluster = {}
clusters = []
means = []
values = sorted(list(set(data)))
for v in values:
  value2cluster[v] = len(clusters)
  clusters.append(set([v]))
  means.append(v)

error_max = 0.0
for _ in range(len(values) - num):
  min_error = 1.0e10
  min_pair = None
  for i in range(len(clusters) - 1):
    v0 = means[i]
    for j in range(i + 1, len(clusters)):
      v1 = means[j]
      error = abs(v0 - v1) / min(v0, v1)
      if error < min_error:
        min_error = error
        min_pair = (i, j)
  error_max = max(error_max, min_error)
  i, j = min_pair
  clusters[i] |= clusters[j]
  means[i] = sum(clusters[i]) / len(clusters[i])
  del clusters[j]
  del means[j]
  for v, c in value2cluster.items():
    if c == j:
      value2cluster[v] = i
    elif c > j:
      value2cluster[v] -= 1

print('Error: %.1f%%' % (100.0 * error_max), file=sys.stderr)
print('Clusters: %s' % means)
print('Data: %s' % [value2cluster[d] for d in data])
