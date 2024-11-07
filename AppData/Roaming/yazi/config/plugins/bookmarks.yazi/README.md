# bookmarks.yazi

A [Yazi](https://github.com/sxyazi/yazi) plugin that Supports persistent bookmark management.No bookmarks are lost after you close yazi.

inspired by [bookmarks](https://github.com/dedukun/bookmarks.yazi)

> [!NOTE]
> The latest main branch of Yazi is required at the moment.


https://github.com/DreamMaoMao/bookmarks.yazi/assets/30348075/cb47efd0-7567-456c-8224-c7ae41130b34


## Installation

```sh
# Linux/macOS
git clone https://github.com/DreamMaoMao/bookmarks.yazi.git ~/.config/yazi/plugins/bookmarks.yazi

# Windows
git clone https://github.com/DreamMaoMao/bookmarks.yazi.git $env:APPDATA\yazi\config\plugins\bookmarks.yazi
```

## Usage

Add this to your `keymap.toml`:

```toml
[[manager.prepend_keymap]]
on = [ "u", "a" ]
run = "plugin bookmarks --args='save'"
desc = "Save current position as a bookmark"

[[manager.prepend_keymap]]
on = [ "u", "g" ]
run = "plugin bookmarks --args='jump'"
desc = "Jump to a bookmark"

[[manager.prepend_keymap]]
on = [ "u", "d" ]
run = "plugin bookmarks --args='delete'"
desc = "Delete a bookmark"

[[manager.prepend_keymap]]
on = [ "u", "D" ]
run = "plugin bookmarks --args='delete_all'"
desc = "Delete all bookmarks"

[[manager.prepend_keymap]]
on = [ "u", "m" ]
run = "plugin bookmarks --args='modify'"
desc = "modify key bind to hoverd path"

```
