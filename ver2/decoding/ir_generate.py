#!/usr/bin/python3

import sys

line = sys.stdin.readline().strip()
assert line.startswith('Clusters: ')
clusters = map(float, line[11:-1].split(','))
line = sys.stdin.readline().strip()
assert line.startswith('Data: ')
data = map(int, line[7:-1].split(','))

t = 1.0 / 38.0e3
for i, c in enumerate(clusters):
  n = int(c * 1.0e-6 / t + 0.5)
  print('pulse%d:' % i)
  print('	ldi	YL, lo8(%d)' % n)
  print('	ldi	YH, hi8(%d)' % n)
  print('	rjmp	pulse')
print('')
print('ext_int:')
print('	clr	XL')
for d in data:
  print('	rcall	pulse%d' % d)
print('	ret')
