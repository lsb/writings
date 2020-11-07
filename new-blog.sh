#!/bin/bash -ex
pushd leebutterman.com
./mkbuilder.sh && ./build.sh
popd
./rsync-site.sh
