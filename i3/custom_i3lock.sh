#!/bin/bash

rectangles=" "

SR=$(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*')
for RES in $SR; do
  SRA=(${RES//[x+]/ })
  CX=$((${SRA[2]} + 25))
  CY=$((${SRA[1]} - 80))
  rectangles+="rectangle $CX,$CY $((CX+300)),$((CY-80)) "
done

# get current background image filename (set by wallpaper_shuffle.sh)
bgfile=$(cat $HOME/.currentbg)

# get screen resolution to resize image correctly
eval "$(xdpyinfo | awk '/dimensions/{print $2}' | awk -Fx '{print "bgw="$1, "bgh="$2 }')"

outfile=/tmp/screen.png
#convert $bgfile -scale 5% -scale 2000% -draw "fill rgba(0,0,0,0.5) $rectangles" $outfile
convert $bgfile -resize ${bgw}x${bgh}! -scale 5% -scale 2000% -draw "fill rgba(0,0,0,0.5) $rectangles" $outfile

i3lock \
  -i $outfile \
  --timepos="x+120:h-120" \
  --datepos="tx+24:ty+25" \
  --clock --datestr "Type password to unlock..." \
  --insidecolor=00000000 --ringcolor=ffffffff --line-uses-inside \
  --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --separatorcolor=00000000 \
  --insidevercolor=fecf4dff --insidewrongcolor=d23c3dff \
  --ringvercolor=ffffffff --ringwrongcolor=ffffffff --indpos="x+290:h-120" \
  --radius=20 --ring-width=3 --veriftext="" --wrongtext="" \
  --verifcolor="ffffffff" --wrongcolor="ffffffff" --timecolor="ffffffff" --datecolor="ffffffff"

rm $outfile