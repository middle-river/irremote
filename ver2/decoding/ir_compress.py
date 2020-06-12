#!/usr/bin/python3

import sys

assert len(sys.argv) == 2, 'usage: %s <number of clusters>' % sys.argv[0]
clusters = int(sys.argv[1])

data = sys.stdin.readline().split()
data = [float(d) for d in data]
assert len(data) >= clusters
values = sorted(data)
intervals = [((values[i + 1] - values[i]) / values[i], values[i]) for i in range(len(values) - 1)]
intervals.sort()
thresholds = sorted([v for _, v in intervals[-(clusters - 1):]])

value2cluster = {}
cluster = 0
means = [[] for _ in range(clusters)]
for v in values:
  value2cluster[v] = cluster
  means[cluster].append(v)
  if cluster < clusters - 1 and v == thresholds[cluster]:
    cluster += 1
for i in range(clusters):
  means[i] = sum(means[i]) / len(means[i])

error_max = 0.0
for d in data:
  error = d - means[value2cluster[d]]
  error = math.sqrt(error * error)
  error = error / d
  error_max = max(error_max, error)
print('Error: %.1f%%' % (100.0 * error_max), file=sys.stderr)

print('Clusters: %s' % means)
print('Data: %s' % [value2cluster[d] for d in data])
