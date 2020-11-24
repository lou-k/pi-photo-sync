# Synchronizing to Lightroom Classic on OSX

This guide walks you through having your pi synchronize to your OSX machine over ssh. After that, you can set Lightroom Classic to auto-import your synchronized directory.

Note that there is no "watch folder" feature for the new, cloud-based Lightroom.

## Enabling SSH Access on OSX

First, you should enable ssh access on OSX.

To do this:
* Open _System Preferences_
* Click _Sharing_
* On the left, check the box next to _Remote Login_
* On the right, select _Only these users_
* Click the _+_ sign
* Select your user

Note that the dialogue shows you how to access your machine. It will say:

_To login to this computer remotely, type "ssh user@machine"_

Take note of the user and machine ip.

From your pi, verify that you can indeed access the machine:

```console
ssh user@machine
```

It will ask you for your OSX password. If successful, you'll see your terminal from your OSX machine.

:bulb: Note: you may need to replace the machine name in the ssh command with the OSX machine's IP address.

## Set Up ssh keys

Next, we'll setup ssh keys between the pi and your osx machine so it can ssh without a password.

* First, generate a key on the pi machine:
```console
ssh-keygen -t ecdsa
```
(if you're not sure what the prompts mean, just leave them as default and don't enter a passphrase)
* And copy it to your osx machine:
```console
ssh-copy-id user@machine
```
(you will be asked for your osx password again)

Now, you should be able to ssh from your pi to your OSX machine without a password:
```console
ssh user@machine
```

## Setting Up Lightroom Classic
Next, you should pick a location on your remote machine that you'll copy the images to. For this demonstration, I've selected `~/Pictures/incoming`.

* Next, open Lightoom Classic, and navigate to _Choose File > Auto Import > Auto Import Settings._
* Click the _Choose_ button next to _Watched Folder_.
* Select the folder that you made.

## Setting up PiPhoto

Finally, setup your PiPhoto to use `rsync` to copy the images to your OSX machine. In your `piphoto.conf` file:
```console
sync_command="rsync -rav -e shh $mount_point user@machine:./Pictures/incoming/"
```

## Caveats

Note that this setup assumes that your camera names the images continuously. If it restarts at 1 each time you erase your card, then the `rsync` command will overwrite images on your OSX machine. I am not sure if/what Lightroom Classic will do in that case.

If you want the remote folder to organize images by date, check out the [Copying and Organizing over SSH](../ssh-copy-and-organize/README.md) setup.
