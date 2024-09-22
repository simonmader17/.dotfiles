Enable this service by executing the following commands:

```bash
ln -s ~/scripts/notifiers/pactl-volume-notifier/pactl-volume-notifier.service ~/.config/systemd/user/pactl-volume-notifier.service
systemctl --user enable pactl-volume-notifier
systemctl --user start pactl-volume-notifier
```
