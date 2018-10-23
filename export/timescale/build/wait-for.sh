#!/bin/bash
set -e
until psql -U "postgres" -c "$@" 2>/dev/null; do
  echo -n .
  sleep 1
done
