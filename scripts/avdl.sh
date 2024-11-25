#!/usr/bin/env bash

# artvee.com downloader script

if [ -z "$1" ]; then
	echo "You have to pass a link"
	exit 1
fi

tmp_html="$(mktemp)"
curl -L "$1" > "$tmp_html"

title="$(xidel "$tmp_html" --xpath='//a[ancestor::h1/@class = "product_title entry-title"]' | xargs)"
artist="$(xidel "$tmp_html" --xpath='//a[ancestor::div/@class = "tartist" and ancestor::div/@class = "woodmart-product-brands-links"]' | xargs)"
dl_link="$(xidel "$tmp_html" --xpath='//div[contains(@class, "dl_med") and contains(., "Standard")]/descendant::a[contains(., "Download")]/@href' | xargs)"

echo "title: <$title>"
echo "artist: <$artist>"
echo "dl_link: <${dl_link%\?*}>"

wget "${dl_link%\?*}" -O "$artist - $title.jpg"

rm "$tmp_html"
