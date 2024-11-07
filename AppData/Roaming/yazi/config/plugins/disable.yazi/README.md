# Used to override some built-in plug-ins that need to be disabled directly with this empty plug-in
```toml
prepend_preloaders= [
  # { mime = "video/*", run = "video-ffmpeg" },
  { mime = "video/*", run = "disable" },
]

```

