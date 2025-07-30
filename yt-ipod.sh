#!/bin/zsh

# Check if URL argument is provided
if [[ -z $1 ]]; then
    echo "Correct usage: yt-ipod LINK"
    exit 1
fi

URL=$1

# Step 1 — Download audio using yt-dlp (format 140 = m4a)
yt-dlp -f 140 --embed-metadata --embed-thumbnail --convert-thumbnails jpg -o "temp_audio.%(ext)s" "$URL"

# Find downloaded file
INPUT=$(ls temp_audio.* 2>/dev/null | head -n 1)

# Check if file exists
if [[ ! -f "$INPUT" ]]; then
    echo "Error! Temp file not created"
    exit 1
fi

# Step 2 — Extract clean title for output filename
TITLE=$(yt-dlp --get-title "$URL" | tr -d '\n' | tr '/:*?"<>|' '_')
OUTFILE="${TITLE}.m4a"

# Step 3 — Convert to WAV (linear PCM, compatible)
ffmpeg -y -i "$INPUT" -ar 44100 -ac 2 -sample_fmt s16 "input.wav"

# Step 4 — Convert WAV to M4A (libfdk_aac) preserving metadata and thumbnail
ffmpeg -y -i input.wav -c:a libfdk_aac -vbr 5 -ar 44100 -ac 2 -map_metadata 0 "$OUTFILE"

# Step 5
ffmpeg -y -i "$OUTFILE" -i "$INPUT" \
  -map 0 -map 1:v -c copy -disposition:v:0 attached_pic "temp_with_thumbnail.m4a" && \
mv "temp_with_thumbnail.m4a" "$OUTFILE"

# Clean up
rm "$INPUT" input.wav

echo ---
echo "Finished! -> $OUTFILE"
