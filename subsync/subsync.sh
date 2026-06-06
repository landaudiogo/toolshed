#! /usr/bin/env bash


files=()
while IFS= read -r line; do
    files+=("$line")
done < <(find . -type f -name "*$1*")

echo "Found the following files:"
for ((i=0; i<${#files[@]}; i++)); do
    echo "  $i ${files[$i]}"
done
echo

read -p "Select video file: " -r videoIdx 
video="${files[$videoIdx]}"
if [[ -z "$video" ]]; then
    echo "Invalid video file selection"
    exit 1;
fi
echo $video
echo

read -p "Select subtitles file: " -r subIdx 
sub="${files[$subIdx]}"
if [[ -z "$sub" ]]; then
    echo "Invalid subtitle file selection"
    exit 1;
fi
echo $sub
echo

alass-cli "$video" "$sub" "$sub"
