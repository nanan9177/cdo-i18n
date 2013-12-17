#!/bin/bash

for x in $(find locales | grep mobile.yml); do
  perl foo.pl < $x > $x.tmp
  mv $x.tmp $x
done
