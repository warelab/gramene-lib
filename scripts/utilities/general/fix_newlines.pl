#!/usr/bin/env perl

while (<>) {
  s/\r$//g;
  s/\r/\n/g;
  print $_;
}
