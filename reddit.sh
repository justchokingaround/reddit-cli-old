#!/bin/sh

# you can replace this with your own libreddit url
BASE_URL="https://reddit.artemislena.eu"

[ -z "$*" ] && printf "Enter a query: " && read -r query || query=$*
query=$(printf "%s" "$query"|tr ' ' '+')
subreddit=$(curl -sL "https://www.reddit.com/search/?q=${query}&type=sr"|tr "<" "\n"|
  sed -nE 's@.*class="_2torGbn_fNOMbGw3UAasPl">r/([^<]*)@\1@p'|fzf --height=20% --cycle)
image_ids=$(curl -s "$BASE_URL/r/$subreddit"|sed -nE 's@.*href="/img/([^"]*)" class="post_media_image short".*@\1@p')

# if directory doesn't exist, create it else delete all files in it
[ ! -d "./$subreddit" ] && mkdir "./$subreddit" || rm -rf "./$subreddit/*"

for image_id in $image_ids; do
  printf "\33[2K\r\033[1;35m%s\033[0m" "Downloading $image_id..."
  curl -# "$BASE_URL/img/$image_id" -o "./$subreddit/$image_id"
done
