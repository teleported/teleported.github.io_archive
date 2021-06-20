hugo version > hugo_version.txt
rm -rf public
hugo
cp -rv public/* ../
git add --all
git commit -m "Updating WebSite"
git push

