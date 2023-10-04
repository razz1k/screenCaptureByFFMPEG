#!/bin/bash
pidOfFFMPEG=$(ps aux | grep -i 'ffmpeg -f x11grab' | grep -v 'grep' | awk '{print $2}')
filePathOutput="/home/$USER/Videos"
filePrefix="screenCapture_"
datePrefix=$(date +'%d-%m-%Y--%H-%M-%S' | sed 's/ //g')
fileFullName="$filePathOutput/$filePrefix$datePrefix.mkv"

if [ -z $pidOfFFMPEG ]; then
  amixer -c 1 sset Capture 75% > /dev/null
  ffmpeg \
-f x11grab -i :0.0 \
-f pulse -i default -ac 2 \
-vf "scale=1280:800" \
-af "highpass=f=100, lowpass=f=3000, volumedetect, volume=2.3" \
-c:a aac -b:a 160k \
-c:v libx264 -preset fast -crf 18 \
-movflags +faststart \
-nostdin -loglevel panic \
$fileFullName &
else
  sleep 0.5 && kill $pidOfFFMPEG &
fi
