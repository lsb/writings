pushd leebutterman.com/ ; docker run -e JEKYLL_ENV=production -v $PWD:/jkl -w /jkl ljkl jekyll build --watch --incremental --verbose ; popd
