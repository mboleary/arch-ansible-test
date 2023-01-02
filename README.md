# arch-ansible-test
Testing Ansible for the usecase of managing Arch Linux

Welcome to `blab` (Brady's Lab)

## Prerequisites

Ansible Collections that need to be installed:
- community.general
- kewlfft.aur

These can be installed by running:
```sh
ansible-galaxy collection install -r requirements.yml
```

## Running

```sh
ansible-playbook ./site.yml -i hosts.yml --tags never
```