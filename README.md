# On Top of Spaghetti 🍝

An animated, musical bash script that brings the classic children's song "On Top of Spaghetti" to life with text-based graphics and 8-bit chiptune music.

## Features

- **7 Animated Scenes** with colorful ASCII art
- **Continuous 8-bit Music** generated in real-time
- **Full Song** with all 5 verses plus finale
- **Smooth Animations** including a rolling meatball sequence
- **Story Progression** from spaghetti dinner to magical tomato tree

## Requirements

- macOS (uses `afplay` for audio playback)
- Python 3 (pre-installed on macOS)
- Bash 3.2+ (default on macOS)
- Terminal with color support

## Installation

```bash
git clone https://github.com/yourusername/spaghetti-song.git
cd spaghetti-song
chmod +x spaghetti_song.sh
```

## Usage

Run the show:
```bash
./spaghetti_song.sh
```

## How It Works

### Music System
The script generates authentic 8-bit chiptune music by:
1. Creating square wave tones at specific frequencies
2. Assembling complete melodies as continuous audio streams
3. Writing WAV files to temp storage
4. Playing them with macOS's `afplay` command

### Animation System
- Uses ANSI color codes for vibrant visuals
- Employs `tput` for cursor positioning
- Multi-frame animations with precise timing
- Synchronized with musical score

## Scenes

1. 🍝 **Spaghetti & Meatball** - Dinner is served
2. 🤧 **The Sneeze** - Uh oh!
3. 📽️ **Rolling Animation** - Watch the meatball roll
4. 🚪 **Out the Door** - It escapes!
5. 🌿 **In the Garden** - Under a bush
6. 🌱 **Growing Sprout** - Something magical
7. 🌳 **Tomato Tree** - The grand finale

## Technical Details

- **Audio Format**: 16-bit PCM WAV, 22050 Hz
- **Waveform**: Square wave (authentic 8-bit sound)
- **Color System**: ANSI escape codes
- **Animation**: Frame-based with sleep timing
- **Compatibility**: macOS bash 3.2+

## Song Duration

Approximately 2 minutes for the complete performance.

## Credits

Based on the classic song "On Top of Spaghetti" (melody from "On Top of Old Smokey")

## License

MIT License - Feel free to use, modify, and share!

## Contributing

Found a bug or have an idea? Open an issue or submit a pull request!

---

*Made with Claude Code* 🤖
