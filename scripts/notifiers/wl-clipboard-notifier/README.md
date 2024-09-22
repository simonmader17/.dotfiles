Enable this service by executing the following commands:

```bash
ln -s ~/scripts/notifiers/wl-clipboard-notifier/wl-clipboard-notifier.service ~/.config/systemd/user/wl-clipboard-notifier.service
```

And start the service via `hyprland.conf`:

```bash
exec-once = systemctl --user start wl-clipboard-notifier.service
```
