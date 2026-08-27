#!/bin/bash

# Usage: ./scatter.sh <input_image> <output_image> <width> <height> <num_copies>
# Example: ./scatter.sh logo.png output.png 1920 1080 25

INPUT="$1"
OUTPUT="$2"
WIDTH="$3"
HEIGHT="$4"
N="$5"

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ] || [ -z "$WIDTH" ] || [ -z "$HEIGHT" ] || [ -z "$N" ]; then
    echo "Usage: $0 <input_image> <output_image> <width> <height> <num_copies>"
    exit 1
fi

# Robustly get input image dimensions
DIMS=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of default=nw=1:nk=1 "$INPUT")
IN_W=$(echo "$DIMS" | head -n 1)
IN_H=$(echo "$DIMS" | tail -n 1)

if [ -z "$IN_W" ] || [ -z "$IN_H" ]; then
    echo "Error: Could not read dimensions of $INPUT"
    exit 1
fi

# Use awk to calculate random positions, rotations, sort them, and build the filtergraph
FILTERGRAPH=$(awk -v in_w="$IN_W" -v in_h="$IN_H" -v out_w="$WIDTH" -v out_h="$HEIGHT" -v n="$N" '
BEGIN {
    srand()

    # 1. Create a transparent base canvas
    filters[0] = "color=c=black@0:s=" out_w "x" out_h ":d=1[base]"

    # 2. Split the input image N times
    split_str = "[0:v]split=" n
    for (i = 0; i < n; i++) {
        split_str = split_str "[s" i "]"
    }
    filters[1] = split_str

    idx = 2

    # 3. Generate properties for each copy and store them in arrays
    for (i = 0; i < n; i++) {
        angle = (rand() * 0.3) - 0.15

        cos_a = cos(angle); if (cos_a < 0) cos_a = -cos_a
        sin_a = sin(angle); if (sin_a < 0) sin_a = -sin_a

        rot_w = int(in_w * cos_a + in_h * sin_a) + 1
        rot_h = int(in_w * sin_a + in_h * cos_a) + 1

        max_x = out_w - rot_w
        max_y = out_h - rot_h

        if (max_x < 0) max_x = 0
        if (max_y < 0) max_y = 0

        x = int(rand() * (max_x + 1)) + 0
        y = int(rand() * (max_y + 1)) + 0

        # Store properties in arrays
        angles[i] = angle
        rot_ws[i] = rot_w
        rot_hs[i] = rot_h
        xs[i] = x
        ys[i] = y

        # Add rotation filter to array
        filters[idx++] = "[s" i "]format=rgba,rotate=a=" angle ":out_w=" rot_w ":out_h=" rot_h ":fillcolor=0x00000000[r" i "]"
    }

    # 4. Sort indices based on Y coordinate (ascending)
    # This ensures images at the top (small Y) are drawn first (layered behind)
    for (i = 0; i < n; i++) {
        order[i] = i
    }

    # Simple bubble sort
    for (i = 0; i < n - 1; i++) {
        for (j = 0; j < n - i - 1; j++) {
            if (ys[order[j]] > ys[order[j+1]]) {
                temp = order[j]
                order[j] = order[j+1]
                order[j+1] = temp
            }
        }
    }

    # 5. Build overlay chain in the sorted order
    prev_label = "base"
    for (k = 0; k < n; k++) {
        i = order[k]
        # Use "o" prefix for overlay outputs to distinguish from rotation "r" outputs
        filters[idx++] = "[" prev_label "][r" i "]overlay=x=" xs[i] ":y=" ys[i] "[o" k "]"
        prev_label = "o" k
    }

    # Join all filters with exactly one semicolon between each
    filtergraph = filters[0]
    for (i = 1; i < idx; i++) {
        filtergraph = filtergraph ";" filters[i]
    }

    # Print the generated filtergraph to stderr for debugging/verification
    print "Generated filtergraph: " filtergraph > "/dev/stderr"

    # Print the final filtergraph to stdout to be captured by the bash variable
    print filtergraph
}')

# Run FFmpeg
# Note: The map target is now [o...] instead of [b...] because of the updated overlay labels
ffmpeg -i "$INPUT" -filter_complex "$FILTERGRAPH" -map "[o$((N-1))]" -frames:v 1 -y "$OUTPUT"

echo "Successfully scattered $N copies into $OUTPUT"