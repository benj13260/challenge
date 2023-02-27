version=$(grep appVersion charts/Chart.yaml | sed 's/appVersion[: "]*//' | sed 's/"//')
echo $version
yarn run build || true
docker build . -t benjk6/challenge:$version -t benjk6/challenge:latest
docker push benjk6/challenge:$latest