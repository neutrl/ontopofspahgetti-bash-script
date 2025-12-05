#!/bin/bash

# On Top of Spaghetti - Animated Story Mode
# A text-based musical adventure

# ANSI Color Codes
RED='\033[0;31m'
BRIGHT_RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BRIGHT_GREEN='\033[1;32m'
BROWN='\033[0;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# 8-bit Music System - Continuous Melodies
# Generate complete melody sequences as single WAV files

# Generate a continuous melody from a sequence of notes
generate_melody() {
    local melody_name=$1
    shift
    local notes_data="$@"

    python3 -c "
import math
import struct
import subprocess
import tempfile
import os

# Note frequencies
notes_freq = {
    'C4': 262, 'D4': 294, 'E4': 330, 'F4': 349,
    'G4': 392, 'A4': 440, 'B4': 494, 'C5': 523,
    'D5': 587, 'E5': 659, 'rest': 0
}

# Parse melody: format is 'NOTE:DURATION NOTE:DURATION ...'
melody = '''$notes_data'''.strip().split()
sample_rate = 22050
all_samples = []

for note_dur in melody:
    if ':' not in note_dur:
        continue
    note, duration = note_dur.split(':')
    duration = float(duration)

    if note == 'rest':
        # Add silence
        num_samples = int(sample_rate * duration)
        all_samples.extend([struct.pack('<h', 0)] * num_samples)
    else:
        freq = notes_freq.get(note, 440)
        num_samples = int(sample_rate * duration)

        for i in range(num_samples):
            t = i / sample_rate
            # Square wave for 8-bit sound
            value = 1.0 if math.sin(2 * math.pi * freq * t) > 0 else -1.0
            # Add slight envelope to prevent clicks
            envelope = 1.0
            if i < 100:  # Fade in
                envelope = i / 100.0
            elif i > num_samples - 100:  # Fade out
                envelope = (num_samples - i) / 100.0
            sample = int(value * 32767 * 0.25 * envelope)
            all_samples.append(struct.pack('<h', sample))

# Create WAV file
wav_data = b'RIFF'
wav_data += struct.pack('<I', 36 + len(all_samples) * 2)
wav_data += b'WAVEfmt '
wav_data += struct.pack('<I', 16)
wav_data += struct.pack('<H', 1)   # PCM
wav_data += struct.pack('<H', 1)   # mono
wav_data += struct.pack('<I', sample_rate)
wav_data += struct.pack('<I', sample_rate * 2)
wav_data += struct.pack('<H', 2)
wav_data += struct.pack('<H', 16)
wav_data += b'data'
wav_data += struct.pack('<I', len(all_samples) * 2)
wav_data += b''.join(all_samples)

# Write to temp file
with tempfile.NamedTemporaryFile(suffix='.wav', delete=False, prefix='spag_${melody_name}_') as f:
    f.write(wav_data)
    print(f.name)
" 2>/dev/null
}

# Play the melody for "On Top of Spaghetti" (based on "On Top of Old Smokey")
# Extended version to match verse display time (8-10 seconds)
play_verse_music() {
    (
        # Generate complete verse melody in 3/4 waltz time
        # Total duration: ~9 seconds to cover the full verse display (4 lines × 1.5s + 2s pause)
        local melody_file=$(generate_melody "verse" "
            C4:0.6 C4:0.5 D4:0.4 E4:0.7 E4:0.6 rest:0.2
            D4:0.6 C4:0.7 G4:0.6 G4:0.5 A4:0.6 G4:0.7 rest:0.2
            F4:0.6 E4:0.7 C4:0.6 C4:0.5 D4:0.6 E4:0.7 rest:0.2
            D4:0.6 C4:0.7 D4:0.6 C4:1.0
        ")

        if [[ -f "$melody_file" ]]; then
            afplay "$melody_file" 2>/dev/null
            rm -f "$melody_file"
        fi
    ) &
}

# Play upbeat chiptune for animations
play_animation_music() {
    (
        local melody_file=$(generate_melody "anim" "
            G4:0.15 C5:0.15 G4:0.15 C5:0.15
            G4:0.15 C5:0.15 G4:0.15 C5:0.15
            A4:0.15 D5:0.15 A4:0.15 D5:0.15
            G4:0.2 E4:0.2 C4:0.3
        ")

        if [[ -f "$melody_file" ]]; then
            afplay "$melody_file" 2>/dev/null
            rm -f "$melody_file"
        fi
    ) &
}

# Play magical growing sound
play_magical_sound() {
    (
        local melody_file=$(generate_melody "magic" "
            C4:0.25 E4:0.25 G4:0.25 C5:0.4 E5:0.3
        ")

        if [[ -f "$melody_file" ]]; then
            afplay "$melody_file" 2>/dev/null
            rm -f "$melody_file"
        fi
    ) &
}

# Title theme - cheerful 8-bit tune
play_title_music() {
    (
        local melody_file=$(generate_melody "title" "
            C4:0.3 E4:0.3 G4:0.3 C5:0.4 rest:0.2
            G4:0.3 E4:0.3 C4:0.4 rest:0.2
            C4:0.2 D4:0.2 E4:0.2 F4:0.2 G4:0.5
        ")

        if [[ -f "$melody_file" ]]; then
            afplay "$melody_file" 2>/dev/null
            rm -f "$melody_file"
        fi
    ) &
}

# Helper functions
clear_screen() {
    clear
    tput cup 0 0
}

print_centered() {
    local text="$1"
    local color="${2:-$NC}"
    local width=$(tput cols)
    local text_length=${#text}
    local padding=$(( (width - text_length) / 2 ))
    printf "%${padding}s" ""
    echo -e "${color}${text}${NC}"
}

pause() {
    sleep "${1:-1}"
}

# Title Screen
show_title() {
    clear_screen
    play_title_music
    echo ""
    echo ""
    print_centered "♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫" "$BRIGHT_RED"
    echo ""
    print_centered "ON TOP OF SPAGHETTI" "$YELLOW"
    print_centered "===================" "$YELLOW"
    echo ""
    print_centered "A Musical Tale" "$CYAN"
    print_centered "(With 8-bit Music!)" "$GRAY"
    echo ""
    print_centered "♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫" "$BRIGHT_RED"
    echo ""
    echo ""
    pause 3
}

# Scene 1: Spaghetti and Meatball on Table
scene1() {
    clear_screen
    echo ""
    echo ""
    echo -e "                    ${BROWN}_______________${NC}"
    echo -e "                   ${BROWN}|               |${NC}"
    echo -e "          ${BROWN}    .-'''-.${NC}     ${BROWN}|${NC}  ${YELLOW}┌─────────┐${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   /       \\${NC}    ${BROWN}|${NC}  ${YELLOW}│ Parmesan│${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}  |  ${BRIGHT_RED}(*)${BROWN}   |${NC}   ${BROWN}|${NC}  ${YELLOW}└─────────┘${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   \\       /${NC}    ${BROWN}|               |${NC}"
    echo -e "          ${YELLOW}    \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}     ${BROWN}|_______________|${NC}"
    echo -e "         ${YELLOW} /${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}         ${BROWN}|   |   |   |${NC}"
    echo -e "        ${YELLOW}/${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}       ${BROWN}|   |   |   |${NC}"
    echo -e "       ${YELLOW}|${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}|${NC}      ${BROWN}└───┴───┴───┘${NC}"
    echo -e "       ${YELLOW}|${RED}~${YELLOW}SPAGHETTI${RED}~${YELLOW}┴${RED}~${YELLOW}|${NC}"
    echo -e "       ${YELLOW} \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}"
    echo -e "        ${YELLOW} \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}        ${BRIGHT_RED}(*) = Meatball${NC}"
    echo -e "         ${YELLOW} \\_______/${NC}"
    echo ""
    echo ""
}

# Scene 2: The Sneeze
scene2_sneeze() {
    clear_screen
    echo ""
    echo ""
    echo -e "                    ${BROWN}_______________${NC}"
    echo -e "          ${CYAN}AH-      ${BROWN}|               |${NC}"
    echo -e "          ${BROWN}    .-'''-.${NC}     ${BROWN}|${NC}  ${YELLOW}┌─────────┐${NC}  ${BROWN}|${NC}"
    echo -e "         ${CYAN}CHOO!${BROWN}/       \\${NC}   ${BROWN}|${NC}  ${YELLOW}│ Parmesan│${NC}  ${BROWN}|${NC}"
    echo -e "      ${CYAN}✲${NC} ${CYAN}✲${NC}  ${BROWN}|  ${BRIGHT_RED}(*)${BROWN}   |${NC}   ${BROWN}|${NC}  ${YELLOW}└─────────┘${NC}  ${BROWN}|${NC}"
    echo -e "       ${CYAN}✲${NC}    ${BROWN}   \\       /${NC}    ${BROWN}|               |${NC}"
    echo -e "          ${YELLOW}    \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}     ${BROWN}|_______________|${NC}"
    echo -e "         ${YELLOW} /${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}         ${BROWN}|   |   |   |${NC}"
    echo -e "        ${YELLOW}/${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}       ${BROWN}|   |   |   |${NC}"
    echo -e "       ${YELLOW}|${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}|${NC}      ${BROWN}└───┴───┴───┘${NC}"
    echo -e "       ${YELLOW}|${RED}~${YELLOW}SPAGHETTI${RED}~${YELLOW}┴${RED}~${YELLOW}|${NC}"
    echo -e "       ${YELLOW} \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}"
    echo -e "        ${YELLOW} \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}"
    echo -e "         ${YELLOW} \\_______/${NC}"
    echo ""
    echo ""
}

# Animation: Meatball Rolling Off
animate_roll() {
    play_animation_music
    # Frame 1: Meatball tips
    clear_screen
    echo ""
    echo ""
    echo -e "                    ${BROWN}_______________${NC}"
    echo -e "                   ${BROWN}|               |${NC}"
    echo -e "          ${BROWN}    .-'''-.${NC}     ${BROWN}|${NC}  ${YELLOW}┌─────────┐${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   /       \\${NC}    ${BROWN}|${NC}  ${YELLOW}│ Parmesan│${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}  | ${BRIGHT_RED}(*)${BROWN}     |${NC}   ${BROWN}|${NC}  ${YELLOW}└─────────┘${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   \\       /${NC}    ${BROWN}|               |${NC}"
    echo -e "          ${YELLOW}    \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}     ${BROWN}|_______________|${NC}"
    echo -e "         ${YELLOW} /${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}         ${BROWN}|   |   |   |${NC}"
    echo ""
    pause 0.3

    # Frame 2: Meatball falls
    clear_screen
    echo ""
    echo ""
    echo -e "                    ${BROWN}_______________${NC}"
    echo -e "                   ${BROWN}|               |${NC}"
    echo -e "          ${BROWN}    .-'''-.${NC}     ${BROWN}|${NC}  ${YELLOW}┌─────────┐${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   /       \\${NC}    ${BROWN}|${NC}  ${YELLOW}│ Parmesan│${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}  |         |${NC}   ${BROWN}|${NC}  ${YELLOW}└─────────┘${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   \\       /${NC}    ${BROWN}|               |${NC}"
    echo -e "          ${YELLOW}    \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}     ${BROWN}|_______________|${NC}"
    echo -e "         ${YELLOW} /${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}   ${BRIGHT_RED}(*)${NC}  ${BROWN}|   |   |   |${NC}"
    echo ""
    pause 0.3

    # Frame 3: Meatball on edge
    clear_screen
    echo ""
    echo ""
    echo -e "                    ${BROWN}_______________${NC}"
    echo -e "                   ${BROWN}|               |${NC}"
    echo -e "          ${BROWN}    .-'''-.${NC}     ${BROWN}|${NC}  ${YELLOW}┌─────────┐${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   /       \\${NC}    ${BROWN}|${NC}  ${YELLOW}│ Parmesan│${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}  |         |${NC}   ${BROWN}|${NC}  ${YELLOW}└─────────┘${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   \\       /${NC}    ${BROWN}|               |${NC}"
    echo -e "          ${YELLOW}    \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}     ${BROWN}|_______________|${NC}"
    echo -e "         ${YELLOW} /${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}         ${BROWN}|   |   |   |${NC}"
    echo -e "        ${YELLOW}/${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}   ${BRIGHT_RED}(*)${NC} ${BROWN}|   |   |   |${NC}"
    echo ""
    pause 0.3

    # Frame 4: Meatball rolling on floor
    clear_screen
    echo ""
    echo ""
    echo -e "                    ${BROWN}_______________${NC}"
    echo -e "                   ${BROWN}|               |${NC}"
    echo -e "          ${BROWN}    .-'''-.${NC}     ${BROWN}|${NC}  ${YELLOW}┌─────────┐${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   /       \\${NC}    ${BROWN}|${NC}  ${YELLOW}│ Parmesan│${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}  |         |${NC}   ${BROWN}|${NC}  ${YELLOW}└─────────┘${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   \\       /${NC}    ${BROWN}|               |${NC}"
    echo -e "          ${YELLOW}    \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}     ${BROWN}|_______________|${NC}"
    echo -e "         ${YELLOW} /${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}         ${BROWN}|   |   |   |${NC}"
    echo -e "        ${YELLOW}/${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}       ${BROWN}|   |   |   |${NC}"
    echo -e "       ${YELLOW}|${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}|${NC}      ${BROWN}└───┴───┴───┘${NC}"
    echo -e "       ${YELLOW}|${RED}~${YELLOW}SPAGHETTI${RED}~${YELLOW}┴${RED}~${YELLOW}|${NC}        ${BRIGHT_RED}(*)${NC} ${RED}~${NC}"
    echo -e "       ${YELLOW} \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}      ${RED}~${NC}"
    echo ""
    pause 0.4
}

# Scene 3: Meatball on the Floor (covered in sauce)
scene3_floor() {
    clear_screen
    echo ""
    echo ""
    echo -e "                    ${BROWN}_______________${NC}"
    echo -e "                   ${BROWN}|               |${NC}"
    echo -e "          ${BROWN}    .-'''-.${NC}     ${BROWN}|${NC}  ${YELLOW}┌─────────┐${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   /       \\${NC}    ${BROWN}|${NC}  ${YELLOW}│ Parmesan│${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}  |         |${NC}   ${BROWN}|${NC}  ${YELLOW}└─────────┘${NC}  ${BROWN}|${NC}"
    echo -e "          ${BROWN}   \\       /${NC}    ${BROWN}|               |${NC}"
    echo -e "          ${YELLOW}    \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}     ${BROWN}|_______________|${NC}"
    echo -e "         ${YELLOW} /${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}         ${BROWN}|   |   |   |${NC}"
    echo -e "        ${YELLOW}/${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}\\${NC}       ${BROWN}|   |   |   |${NC}"
    echo -e "       ${YELLOW}|${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}|${NC}      ${BROWN}└───┴───┴───┘${NC}"
    echo -e "       ${YELLOW}|${RED}~${YELLOW}SPAGHETTI${RED}~${YELLOW}┴${RED}~${YELLOW}|${NC}"
    echo -e "       ${YELLOW} \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}           ${RED}.${NC}"
    echo -e "        ${YELLOW} \\${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}┴${RED}~${YELLOW}/${NC}         ${RED}/${BRIGHT_RED}(*)${RED}\\${NC}"
    echo -e "         ${YELLOW} \\_______/${NC}          ${RED}'---'${NC}"
    echo ""
    echo -e "                       ${BRIGHT_RED}Poor Meatball!${NC}"
    echo ""
}

# Scene 4: Meatball rolling out the door
scene4_door() {
    clear_screen
    echo ""
    echo ""
    echo -e "        ${BROWN}┌──────────────┐${NC}             ${CYAN}┌────────┐${NC}"
    echo -e "        ${BROWN}│${NC}              ${BROWN}│${NC}             ${CYAN}│  DOOR │${NC}"
    echo -e "        ${BROWN}│${NC}   KITCHEN    ${BROWN}│${NC}             ${CYAN}│   ${WHITE}O${CYAN}    │${NC}"
    echo -e "        ${BROWN}│${NC}              ${BROWN}│${NC}      ${BRIGHT_RED}(*)${NC}    ${CYAN}│        │${NC}"
    echo -e "        ${BROWN}│${NC}   ${YELLOW}[Table]${NC}    ${BROWN}│${NC}     ${RED}~${NC} ${RED}→${NC}    ${CYAN}│        │${NC}"
    echo -e "        ${BROWN}└──────────────┘${NC}             ${CYAN}└────────┘${NC}"
    echo ""
    echo -e "              ${BRIGHT_RED}It rolled off the table${NC}"
    echo -e "              ${BRIGHT_RED}And onto the floor...${NC}"
    echo ""
}

# Scene 5: Garden with bush
scene5_garden() {
    clear_screen
    echo ""
    echo -e "                 ${YELLOW}    .${NC}      ${YELLOW}.${NC}"
    echo -e "                ${YELLOW}  .   ${NC}      ${YELLOW}.   .${NC}"
    echo -e "                 ${YELLOW}.  ${NC}  ${YELLOW}☀${NC}  ${YELLOW}.  .${NC}"
    echo -e "                  ${YELLOW}.      .${NC}"
    echo ""
    echo -e "         ${GREEN}    .---.${NC}              ${GREEN}   ___${NC}"
    echo -e "         ${GREEN}  .'     '.${NC}            ${GREEN} /     \\${NC}"
    echo -e "         ${GREEN} /  ${BRIGHT_RED}(*)${GREEN}    \\${NC}    ${GREEN}▓▓▓${NC}   ${GREEN}| ${BRIGHT_GREEN}╱╲╱╲${GREEN} |${NC}"
    echo -e "         ${GREEN}|           |${NC}  ${GREEN}▓▓▓▓▓${NC}  ${GREEN}\\${BRIGHT_GREEN}╱╲╱╲╱${GREEN}/${NC}"
    echo -e "         ${GREEN} \\         /${NC}  ${GREEN}▓▓▓▓▓▓▓${NC}  ${GREEN}'---'${NC}"
    echo -e "          ${GREEN}'-------'${NC}    ${GREEN}▓▓▓▓▓▓▓${NC}"
    echo -e "              ${BROWN}|${NC}          ${GREEN}▓▓▓▓▓${NC}     ${BROWN}|${NC}"
    echo -e "              ${BROWN}|${NC}           ${GREEN}▓▓▓${NC}      ${BROWN}|${NC}"
    echo -e "         ${GRAY}~~~~~${BROWN}|${GRAY}~~~~~~~~~~~~~~~~~~~~~${BROWN}|${GRAY}~~~~~${NC}"
    echo ""
    echo -e "            ${BRIGHT_RED}Under a bush in the garden!${NC}"
    echo ""
}

# Scene 6: Tree Growing (Early stage)
scene6_growing() {
    play_magical_sound
    clear_screen
    echo ""
    echo ""
    echo -e "                 ${YELLOW}    .${NC}      ${YELLOW}.${NC}"
    echo -e "                ${YELLOW}  .   ${NC}      ${YELLOW}.   .${NC}"
    echo -e "                 ${YELLOW}.  ${NC}  ${YELLOW}☀${NC}  ${YELLOW}.  .${NC}"
    echo ""
    echo -e "                    ${BRIGHT_GREEN}|${NC}"
    echo -e "                    ${BRIGHT_GREEN}|${NC}"
    echo -e "                   ${BRIGHT_GREEN}/${GREEN}▓${BRIGHT_GREEN}\\${NC}"
    echo -e "                  ${BRIGHT_GREEN}/${GREEN}▓▓▓${BRIGHT_GREEN}\\${NC}"
    echo -e "                 ${BRIGHT_GREEN}/${GREEN}▓▓${BRIGHT_RED}●${GREEN}▓▓${BRIGHT_GREEN}\\${NC}        ${BRIGHT_RED}● ${NC}= Meatball/Tomato"
    echo -e "                  ${BROWN}|   |${NC}"
    echo -e "                  ${BROWN}|   |${NC}"
    echo -e "         ${GRAY}~~~~~~~~~${BROWN}|   |${GRAY}~~~~~~~~~${NC}"
    echo ""
    echo -e "              ${BRIGHT_GREEN}A tiny sprout appears!${NC}"
    echo ""
}

# Scene 7: Full Tomato Tree
scene7_tree() {
    play_magical_sound
    clear_screen
    echo ""
    echo -e "                 ${YELLOW}    .${NC}      ${YELLOW}.${NC}"
    echo -e "                ${YELLOW}  .   ${NC}      ${YELLOW}.   .${NC}"
    echo -e "                 ${YELLOW}.  ${NC}  ${YELLOW}☀${NC}  ${YELLOW}.  .${NC}"
    echo ""
    echo -e "                  ${BRIGHT_RED}●${NC}   ${BRIGHT_RED}●${NC}"
    echo -e "               ${BRIGHT_RED}●${NC}  ${GREEN}▓▓▓▓▓${NC}  ${BRIGHT_RED}●${NC}"
    echo -e "                 ${GREEN}▓${BRIGHT_GREEN}/${BRIGHT_RED}●${BRIGHT_GREEN}╲${GREEN}▓${BRIGHT_GREEN}/${BRIGHT_RED}●${BRIGHT_GREEN}╲${NC}"
    echo -e "              ${BRIGHT_RED}●${NC} ${GREEN}▓▓${BRIGHT_GREEN}╱${NC} ${BRIGHT_RED}●${NC} ${BRIGHT_GREEN}╲${GREEN}▓▓${NC} ${BRIGHT_RED}●${NC}"
    echo -e "                ${GREEN}▓▓▓${BRIGHT_GREEN}|${NC} ${BRIGHT_RED}●${NC} ${BRIGHT_GREEN}|${GREEN}▓▓▓${NC}"
    echo -e "                 ${GREEN}▓▓▓▓${BRIGHT_RED}●${GREEN}▓▓▓${NC}"
    echo -e "               ${BRIGHT_RED}●${NC} ${GREEN}▓▓▓▓▓▓▓${NC} ${BRIGHT_RED}●${NC}"
    echo -e "                  ${BROWN}|     |${NC}"
    echo -e "                  ${BROWN}|     |${NC}"
    echo -e "                  ${BROWN}|     |${NC}"
    echo -e "         ${GRAY}~~~~~~~~${BROWN}|     |${GRAY}~~~~~~~~${NC}"
    echo ""
    echo -e "         ${BRIGHT_GREEN}A beautiful tomato tree!${NC}"
    echo -e "         ${RED}All covered with meatballs!${NC}"
    echo ""
}

# Display lyrics with scene
display_verse() {
    local verse_num=$1
    shift
    local lines=("$@")

    play_verse_music

    echo ""
    print_centered "♪ Verse $verse_num ♪" "$CYAN"
    echo ""

    for line in "${lines[@]}"; do
        print_centered "$line" "$WHITE"
        pause 1.5
    done

    pause 2
}

# Main performance
main() {
    # Hide cursor
    tput civis

    show_title

    # Verse 1
    scene1
    display_verse 1 \
        "On top of spaghetti," \
        "All covered with cheese," \
        "I lost my poor meatball," \
        "When somebody sneezed."

    # The sneeze!
    scene2_sneeze
    pause 1

    # Verse 2 - The roll
    animate_roll
    display_verse 2 \
        "It rolled off the table," \
        "And onto the floor," \
        "And then my poor meatball," \
        "Rolled out of the door."

    scene4_door
    pause 2

    # Verse 3 - In the garden
    scene5_garden
    display_verse 3 \
        "It rolled in the garden," \
        "And under a bush," \
        "And then my poor meatball," \
        "Was nothing but mush."

    # Verse 4 - The sprout
    scene6_growing
    display_verse 4 \
        "The mush was as tasty," \
        "As tasty could be," \
        "And then the next summer," \
        "It grew into a tree."

    # Verse 5 - The tree
    scene7_tree
    display_verse 5 \
        "The tree was all covered," \
        "All covered with moss," \
        "And on it grew meatballs," \
        "And tomato sauce."

    # Finale
    pause 2
    clear_screen
    echo ""
    echo ""
    echo ""
    print_centered "♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫" "$BRIGHT_RED"
    echo ""
    print_centered "So if you eat spaghetti," "$YELLOW"
    pause 1.5
    print_centered "All covered with cheese," "$YELLOW"
    pause 1.5
    print_centered "Hold onto your meatballs," "$YELLOW"
    pause 1.5
    print_centered "And don't ever sneeze!" "$YELLOW"
    echo ""
    print_centered "♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫" "$BRIGHT_RED"
    echo ""
    echo ""
    print_centered "THE END" "$BRIGHT_GREEN"
    echo ""
    echo ""

    # Show cursor
    tput cnorm
}

# Run the show!
main
