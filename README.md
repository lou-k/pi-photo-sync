# pi-photo-sync
This project turns your raspberry pi into a photo uploader for your SD cards. It's pretty hadny if your DSLR doesn't have wifi and you want to copy your photos to a server/the cloud without opening your computer.

# Usage

Insert your sd card reader into the pi's usb port.

The green led will start flashing as it is processed.

Once complete, the led's will indicate success of failure:
* A solid green indicates the job was successful
* A blinking red indicates the job failed

When you remove the sd card, the leds return to usual pi indicators.

# Installation
Setup your pi, and then run
```
sudo ./install.sh
```

# Configuration

## ssh
First, set up ssh on your pi to authenticate with your server [using keys](https://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/).

Next, update `~/.ssh/config` to make sshing into your server seamless. An example is in `./config/ssh` that looks like:

```
Host upstream
    User MyRemoteUser
    HostName 192.xxx
    Port 22
    ControlPath ~/.ssh/ctl-%h-%p-%r
```

`ControlPath` is currently required for this to work well.

If everything is set up correctly, you should be able to

```ssh upstream```

and get to your remote host without a password.

## udev
The udev rules are written to `/etc/udev/rules/99-mediastorage_card_instert_run.rules` during installation. 

They will configure your pi to mount usb devices to `/media` when inserted.

If you wish to change the mount point, edit the rules file and then run:
```
udevadm control --reload
```
Note also you'll need to make the mount point correspond in `piphoto.conf`

## piphoto.conf

Next, create a new configuration file:
```
sudo cp config/piphoto.conf.example /etc/piphoto.conf
```
and edit it with your favorite editor.

The variables that need to be set are:
* **dest_host** - should match the `Host` in your `~/.ssh/config`
* **dest_path** - the path on your remote machine to put the photos
* **remove_after_sync** - if 1, the images are **DELETED** from your card after upload. _Use with caution_.
* **mount_point** - Where your sd card gets mounted (should match the point in the udev rules above.)

## systemd service
The install script creates the file `/etc/systemd/system/piphoto.service`. It instructs the system to run `phiphoto` when the sd card is mounted under the `pi` user.

If you are using a different default user, or want to change any behavior, edit the script and then run:

```
systemctl daemon-reload
```

The install script also enables the service by default.

# Debugging and Troubleshooting
Logs are accessible via journalctl:
```
journalctl -f -u piphoto.service
```

You can fire the udev trigger without re-inserting the card with:
```
sudo udevadm trigger --action=add <device>
```
where `<device>` is your device file like `/dev/sda` etc.

# License
MIT License (See [LICENSE file](LICENSE))