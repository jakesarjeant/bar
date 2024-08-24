# My AGS Bar

https://github.com/user-attachments/assets/725d609f-776a-4601-bef6-e07b1b201348

Per popular demand (i.e. one person on reddit), this is my (incredibly messy) bar that I made with AGS. You can either run it using the provided nix flake, or try to figure out a way to build it yourself without nix – I've never tried, but it should be as simple as compiling the typescript source in `config/` the same way it's done in `config/default.nix` and putting the result in your `~/.config/ags`.

A nerd font is required to display the system status widget.

The bar will try to load a JSON configuration file from `~/.config/jdesk/config.json` or use reasonable defaults if none is found (By default, the bar is displayed on the left with floating modules). On configuration changes, the bar reloads automatically. Here's my config:

```json
{
  "space": 4,
  "radius": 8,
  "font": {
    "family": "JetBrainsMono Nerd Font",
    "size": 11
  },
  "bar": {
    "mode": "solid",
    "vertical": true,
    "position": "start",
    "style": {
      "bg": "rgba(0,0,0,0.8)"
    },
    "layout": {
      "start": [
        "launcher",
        "date",
        "systray",
        "expander"
      ],
      "center": [],
      "end": [
        "expander",
        "system",
        "time",
        "battery"
      ]
    }
  }
}
```

The source also includes a workspace module that was made for Hyprland, but had to commented out to make the bar run on niri.

## Known Issues

- Each reload makes the bar slightly slower due to a memory leak related to the way css is handled that I've not been able to resolve.
- The bar does not react to monitor changes, so if your monitor configuration changes, new monitors won't get bars until you manually restart it (run `pkill ags && jbar`). This also means that if a monitor disconnects and reconnects, i.e. because it went into standby, the bar will be gone there as well.
