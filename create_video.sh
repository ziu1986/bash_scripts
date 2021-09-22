#! /bin/bash

for i in {1..9}; do
    if [ ! -e tmp0$i.mp4 ]; then
        ffmpeg -loop 1 -y -i images/2021-10-08-stefanie_falk_$i.png -i audio/Slide0$i.mp3 -acodec copy -vcodec libx264 -vbr 1 -shortest output.mp4
        mv output.mp4 tmp0$i.mp4
    fi
done

ffmpeg -f concat -safe 0 -i <(for f in ./tmp*.mp4; do echo "file '$PWD/$f'"; done) -c copy output.mp4
mv output.mp4 f_191.mp4
