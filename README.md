# PiPhoto Sync
This project turns your raspberry pi into a photo uploader for your SD cards. It's pretty handy if your DSLR doesn't have wifi and you want to copy your photos to a server/the cloud without opening your computer.

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

# Destinations

You can customize PiPhoto to syncronize to different places by editing the `sync_command` (see below) that gets triggered when you insert your card.

Detailed setup instructions are available for:
* [ssh](src/destinations/ssh/README.md)
* more to come soon.

# Configuration

## piphoto.conf

Create a new configuration file:
```
sudo cp config/piphoto.conf.example /etc/piphoto.conf
```
and edit it with your favorite editor.

The variables that need to be set are:
* **mount_point** - Where your sd card gets mounted (should match the point in the udev rules above.)
* **run_as_user** - The user to run the sync program as.
* **sync_command** - What command to run to sync the photos. (See _Destinations_ above).

## udev
The udev rules are written to `/etc/udev/rules/99-mediastorage_card_instert_run.rules` during installation. 

They will configure your pi to mount usb devices to `/media` when inserted.

If you wish to change the mount point, edit the rules file and then run:
```
udevadm control --reload
```
Note also you'll need to make the mount point correspond in `piphoto.conf`

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