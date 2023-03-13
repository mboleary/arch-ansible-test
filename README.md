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

Provisioning is split into 2 groups; `bootstrap` and `ansible`.

If creating a VM for testing, ensure that it's configured to use UEFI instead of BIOS.

### Bootstrap
This collection is meant to provision a system from nothing, and get it into a usable state.

Before the playbook can be run on a fresh system, the following must be done:

1. Run `ssh-copy-id root@<hostname>` to copy the ssh keys to the host

2. Open `site.yml` (or other equivalent place) and edit the configuration for the new machine. Details on this configuration may be found in the docs

3. Run the following command, which WILL ERASE DATA ON THE DISK!
```sh
ansible-playbook ./site.yml -i hosts.yml --tags never,bootstrap
```

4. Reboot the machine by running `reboot` in the terminal. If running on a VM using qemu/kvm, it may be necessary to shut down the vm in order to remove the livecd iso from the virtual cd drive.

5. Remove the host from the `provision` group and add it to the `postinstall` group.

At this point, you should be rebooted into a working system and met with the standard login prompt on a linux workstation without a display manager installed. You should take heed that the ip address may be different than the first time around, and you will need to update your `site.yml` file accordingly. The root password is not set this time, and the only way into the system at this point is using the ssh keys copied over from the ansible host. We are now in the __postinstall__ phase of bootstrap.

6. Run the following command, which will configure the users on the system and also configure the ssh server to lock out the root user:
```sh
ansible-playbook ./site.yml -i hosts.yml --tags postinstall
```

At this point, the system should be ready for use in the main playbook. It will have 2 users added; your user account, and a control user named `ansible`. Both of these users have root access via sudo, and the control user is only able to login using the ssh keys from the ansible host.

### System Configuration
There are additional steps available to configure and customize the system setup with desktop environments as well as installing other software.

1. Open the hosts.yml file and update your system configuration to work in tandem with the roles listed in `site.yml`

2. Run `ansible-playbook ./site.yml -i hosts.yml --tags configure,users` to install some base software and configure user accounts

3. Run `ansible-playbook ./site.yml -i hosts.yml --tags <tag>` with whatever tag is needed to get the system into the final configuration

#### Full-Disk Encryption Note

If `crypt_lvm` was used for the disk layout, then be sure to change your FDE password away from the temporary one. See [the ArckWiki article on this](https://wiki.archlinux.org/title/dm-crypt/Device_encryption#Cryptsetup_actions_specific_for_LUKS) for more information.

### Ansible
This collection is meant to broadly configure a bootstrapped system, meaning that these tasks will do basic maintenance, including updates, checking disk health, etc. These tasks are also responsible for installing packages to configure a system in a particular way.

### Directories

- `/var/log/arch-ansible`
- `/usr/share/arch-ansible`