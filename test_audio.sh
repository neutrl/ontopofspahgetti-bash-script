#!/bin/bash

# Quick audio test for the spaghetti song

echo "Testing 8-bit audio system..."
echo "You should hear a short ascending melody."
echo ""

# Note definitions
declare -A NOTES=(
    ["C4"]=262
    ["E4"]=330
    ["G4"]=392
    ["C5"]=523
)

# Play a note
play_note() {
    local note=$1
    local duration=${2:-0.3}
    local freq=${NOTES[$note]}

    python3 -c "
import math
import struct
import subprocess
import tempfile
import os

freq = $freq
duration = $duration
sample_rate = 22050
num_samples = int(sample_rate * duration)

# Generate square wave (8-bit style)
samples = []
for i in range(num_samples):
    t = i / sample_rate
    value = 1.0 if math.sin(2 * math.pi * freq * t) > 0 else -1.0
    sample = int(value * 32767 * 0.3)
    samples.append(struct.pack('<h', sample))

# Create WAV file
wav_data = b'RIFF'
wav_data += struct.pack('<I', 36 + len(samples) * 2)
wav_data += b'WAVEfmt '
wav_data += struct.pack('<I', 16)
wav_data += struct.pack('<H', 1)
wav_data += struct.pack('<H', 1)
wav_data += struct.pack('<I', sample_rate)
wav_data += struct.pack('<I', sample_rate * 2)
wav_data += struct.pack('<H', 2)
wav_data += struct.pack('<H', 16)
wav_data += b'data'
wav_data += struct.pack('<I', len(samples) * 2)
wav_data += b''.join(samples)

with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as f:
    f.write(wav_data)
    temp_file = f.name

subprocess.run(['afplay', temp_file])
os.unlink(temp_file)
"
}

echo -n "Playing C4... "
play_note "C4" 0.4
echo "✓"

echo -n "Playing E4... "
play_note "E4" 0.4
echo "✓"

echo -n "Playing G4... "
play_note "G4" 0.4
echo "✓"

echo -n "Playing C5... "
play_note "C5" 0.5
echo "✓"

echo ""
echo "Audio test complete! If you heard 4 beeps, the music system is working."
echo "Run ./spaghetti_song.sh to enjoy the full show!"
