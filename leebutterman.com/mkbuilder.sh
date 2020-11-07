docker build -t ljkl --build-arg GEMFILE=$(cat Gemfile | base64 -w 0) --build-arg GEMFILELOCK=$(cat Gemfile.lock | base64 -w 0) - < ./Dockerfile

