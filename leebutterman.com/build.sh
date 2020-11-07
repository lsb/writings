rm /home/lsb/writings/leebutterman.com/light-pollution-topography
docker run -e JEKYLL_ENV=production -v $PWD:/jkl -w /jkl -u $UID ljkl jekyll build
ln -s /home/ubuntu/visualizing-light-pollution/light-pollution-topography/build/ /home/lsb/writings/leebutterman.com/light-pollution-topography
ln -s /home/ubuntu/visualizing-light-pollution/light-pollution-topography/build/ /home/lsb/writings/leebutterman.com/_site/light-pollution-topography
