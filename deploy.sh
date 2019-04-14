#!/usr/bin/env bash

# Build
./sidt.sh -m python2
./sidt.sh -m python3

# Test
./sidt.sh -u infra
./sidt.sh -u test-extensive
./sidt.sh -d all

# push to docker registry
./sidt.sh -x python2
./sidt.sh -x python3
