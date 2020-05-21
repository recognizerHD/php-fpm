#!/usr/bin/env sh
crond &
exec "$@"
