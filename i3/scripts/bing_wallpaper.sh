#!/bin/sh

json=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US")
urlbase=$(echo "$json" | jq -r '.images[0].urlbase')
url="https://www.bing.com${urlbase}_UHD.jpg"

wget -O /tmp/wall.jpg "$url"
feh --bg-fill /tmp/wall.jpg
