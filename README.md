# molecule_rocky_9

A [Packer](https://www.packer.io/) project to build an image of Rocky Linux 9
suitable for use with
[dtmo/molecule_driver_libvirt](https://github.com/dtmo/molecule_driver_libvirt).

The built image is a minimal installation of Rocky Linux 9 with all package
updates applied.

## Installed Packages

* [Cloud-init](https://cloudinit.readthedocs.io/en/stable/): Cloud-init is used
  by `dtmo/molecule_driver_libvirt` to perform initial VM configuration.
* [QEMU Guest Agent](https://wiki.qemu.org/Features/GuestAgent): QEMU Guest
  Agent is used to provide hypervisor access to the VM.
  `dtmo/molecule_driver_libvirt` uses it to determine when Cloud-init has
  finished initializing the VM, and to retrieve network information about the
  guest OS.

## Cloud-init Configuration

Cloud-init is configured to use the
[NoCloud Datasource](https://cloudinit.readthedocs.io/en/stable/reference/datasources/nocloud.html), falling back to the
[None Datasource](https://cloudinit.readthedocs.io/en/stable/reference/datasources/none.html)
if no configuration can be discovered.

When used with `dtmo/molecule_driver_libvirt` the image will be configured with
the Cloud-init
[NoCloud Datasource](https://cloudinit.readthedocs.io/en/stable/reference/datasources/nocloud.html)
using configuration set by the Molecule driver.

When a VM is created from the image and booted with no configuration, Cloud-init
will fall back to the
[None Datasource](https://cloudinit.readthedocs.io/en/stable/reference/datasources/none.html)
which is configured to create the distro default cloud user: `cloud-user`, and
with the password `password`. Password based authentication will be enabled and
no SSH keys installed.

## Building

### Pre-requisites

* HashiCorp Packer must be installed to execute the build process. See:
  [Install Packer](https://developer.hashicorp.com/packer/install).

* QEMU is required for the Packer
  [QEMU Integration](https://developer.hashicorp.com/packer/integrations/hashicorp/qemu)
  to perform the image build.

### Build Process

```bash
packer init .
packer build .
```

The built QCOW2 image will be written to: `output-rocky9/packer-rocky9`.
