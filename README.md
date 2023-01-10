# arch-ansible-test
Testing Ansible for the usecase of managing Arch Linux

Welcome to `blab` (Brady's Lab)

## Prerequisites

Ansible Collections that need to be installed:
- community.general
- kewlfft.aur

Host must have the following installed:
- ansible
- sshpass

These can be installed by running:
```sh
ansible-galaxy collection install -r requirements.yml
```

## Running

Before the playbook can be run on a fresh system, the following must be done:

1. Run `ssh-copy-id root@<hostname>` to copy the ssh keys to the host

2. Open `site.yml` (or other equivalent place) and edit the configuration for the new machine. Details on this configuration may be found in the docs

3. Run the following command, which WILL ERASE DATA ON THE DISK!
```sh
ansible-playbook ./site.yml -i hosts.yml --tags never,bootstrap
```

4. Reboot the machine by running `reboot` in the terminal. If running on a VM using qemu/kvm, it may be necessary to shut down the vm in order to remove the livecd iso from the virtual cd drive.

5. Remove the host from the `provision` group and add it to the `postinatll` group.

At this point, you should be rebooted into a working system and met with the standard login prompt on a linux workstation without a display manager installed. You should take heed that the ip address may be different than the first time around, and you will need to update your `site.yml` file accordingly. The root password is not set this time, and the only way into the system at this point is using the ssh keys copied over from the ansible host. We are now in the __postinstall__ phase of bootstrap.

6. Run the following command, which will configure the users on the system and also configure the ssh server to lock out the root user:
```sh
ansible-playbook ./site.yml -i hosts.yml --tags postinstall
```

At this point, the system should be ready for use in the main playbook. It will have 2 users added; your user account, and a control user named `ansible`. Both of these users have root access via sudo, and the control user is only able to login using the ssh keys from the ansible host.