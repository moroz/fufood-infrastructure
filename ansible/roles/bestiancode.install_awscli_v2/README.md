# Ansible Role · install_awscli_v2

Automates the installation of the official AWS Command Line Interface v2 on Linux hosts.

## Installation

Install from Ansible Galaxy (preferred):

```bash
ansible-galaxy role install bestiancode.install_awscli_v2
```

Or, install directly from GitHub:

```bash
ansible-galaxy role install git+https://github.com/BestianCode/ansible.role.install_awscli_v2.git
```

Sample `requirements.yml` entry:

```yaml
roles:
  - name: bestiancode.install_awscli_v2
    version: latest
```

Then run `ansible-galaxy install -r requirements.yml` as usual.

## Usage

Minimal playbook example:

```yaml
- hosts:
    - all
  become: true
  roles:
    - bestiancode.install_awscli_v2
```

## Links

- **GitHub**: [https://github.com/BestianCode/ansible.role.install_awscli_v2](https://github.com/BestianCode/ansible.role.install_awscli_v2)
- **Galaxy**: [https://galaxy.ansible.com/ui/standalone/roles/BestianCode/install_awscli_v2](https://galaxy.ansible.com/ui/standalone/roles/BestianCode/install_awscli_v2)
