# Xcode Extensions

## Installation

- Download the `*.app.zip` file in [releases](https://github.com/hlung/XcodeExtensions/releases) page (or build from source code if you don't trust me :P)
- Run the app once, then close it
- Open Xcode, open some .swift file
- The command should appear at the bottom of Editor menu

To manage extensions, go to System Preferences > Extension > Xcode Source Editor

## Commands

### Expand Selection

This command uses the selected text to expand selection to the next occurance of that text. This allows fast multi-selection refactoring of any text.

This is the same feature as Sublime Text's `Selection > Expand Selection to Word` (cmd+D) command.

![demo](README/demo-expand-selection.gif)

#### Limitation

- Not yet working with a selection that spans across multiple lines.
- Not yet support searching back at beginning after reaching end of file.
