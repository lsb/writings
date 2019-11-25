#!/bin/bash -ex
pushd leebutterman.com
./mkbuilder.sh && ./build.sh
popd
scp -r leebutterman.com ubuntu@23.23.94.95:.
