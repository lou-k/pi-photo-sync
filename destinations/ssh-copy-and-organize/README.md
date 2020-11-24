# PiPhoto SSH Syncing

The `piphoto-ssh-sync` script will upload your photos to a remote machine using ssh while simultaneously organizing them by date.

On the remote host, the images are organized in directories named `YYYY/YYYY-MM-DD/` based on the exif data of the file. For example:
```
2020
├── 2020-11-01
│   ├── DSC_0536.NEF
│   ├── DSC_0537.NEF
│   ├── DSC_0538.NEF
├── 2020-11-07
│   ├── DSC_0001.NEF
│   ├── DSC_0002.NEF
│   ├── DSC_0003.NEF
...
```

This script is installed by default when you install piphoto.

You can also use this script as a stand alone program to copy-and-organize images at the same time.

## Usage

The `piphoto-ssh-sync` will read options from `/etc/piphoto.ssh.conf` or the command line (see `piphoto-ssh-sync -h` for options).

## SSH Configuration
First, set up ssh on your pi to authenticate with your server [using keys](https://www.tecmint.com/ssh-passwordless-login-using-ssh-keygen-in-5-easy-steps/).

Next, update `~/.ssh/config` to make sshing into your server seamless. An example is in `ssh.config.example` that looks like:

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

## Configuration
`piphoto-ssh-sync` reads from `/etc/piphoto.ssh.conf`. An example is provided in `piphoto.ssh.conf.example`. 

The variables that need to be set are:
* **dest_host** - should match the `Host` in your `~/.ssh/config`
* **dest_path** - the path on your remote machine to put the photos

## Testing
Once you've configured `piphoto-ssh-sync` and your ssh keys, run:
```
piphoto-ssh-sync path_to_images
```
to ensure it's working properly.

## Usage with piphoto
Once `piphoto-ssh-sync`, you can use it with `pihoto` to sync images when your sd card is inserted.
Simply edit `/etc/piphoto.conf` and set:
```
sync_command="piphoto-ssh-sync $mount_point"
```