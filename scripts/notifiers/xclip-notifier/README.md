Enable this service by executing the following commands:

```bash
ln -s ~/scripts/notifiers/xclip-notifier/xclip-notifier.service ~/.config/systemd/user/xclip-notifier.service
systemctl --user enable xclip-notifier
systemctl --user start xclip-notifier
```

Because X server has to run for this script to work and `graphical-session.target` is not started automatically by Xorg, we need to explicitly start it (Refer to [https://superuser.com/a/1128905/636739](https://superuser.com/a/1128905/636739)):

Add this to your `~/.xsessionrc`:

```bash
systemctl --user import-environment PATH DBUS_SESSION_BUS_ADDRESS
systemctl --no-block --user start xsession.target
```

Create `~/.config/systemd/user/xsession.target`:

```bash
[Unit]
Description=Xsession running
BindsTo=graphical-session.target
```
