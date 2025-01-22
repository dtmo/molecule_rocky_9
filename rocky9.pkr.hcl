packer {
  required_plugins {
    qemu = {
      version = "~> 1.1"
      source  = "github.com/hashicorp/qemu"
    }

    sshkey = {
      version = ">= 1.1.0"
      source  = "github.com/ivoronin/sshkey"
    }
  }
}

data "sshkey" "provisioning" {
  name = var.ssh_username
  type = "ed25519"
}

source "qemu" "rocky9" {
  # Qemu Specific Configuration

  iso_skip_cache       = var.iso_skip_cache
  accelerator          = var.accelerator
  disk_additional_size = var.disk_additional_size
  firmware             = var.firmware
  use_pflash           = var.use_pflash
  disk_interface       = var.disk_interface
  disk_size            = var.disk_size
  skip_resize_disk     = var.skip_resize_disk
  disk_cache           = var.disk_cache
  disk_discard         = var.disk_discard
  disk_detect_zeroes   = var.disk_detect_zeroes
  skip_compaction      = var.skip_compaction
  disk_compression     = var.disk_compression
  format               = var.format
  headless             = var.headless
  disk_image           = var.disk_image
  use_backing_file     = var.use_backing_file
  machine_type         = var.machine_type
  memory               = var.memory
  net_device           = var.net_device
  net_bridge           = var.net_bridge
  output_directory     = var.output_directory
  qemuargs             = var.qemuargs

  qemu_binary         = var.qemu_binary
  qmp_enable          = var.qmp_enable
  qmp_socket_path     = var.qmp_socket_path
  use_default_display = var.use_default_display
  vga                 = var.vga
  display             = var.display
  vnc_bind_address    = var.vnc_bind_address
  vnc_use_password    = var.vnc_use_password
  vnc_port_min        = var.vnc_port_min
  vnc_port_max        = var.vnc_port_max
  vm_name             = var.vm_name
  cdrom_interface     = var.cdrom_interface
  vtpm                = var.vtpm
  use_tpm1            = var.use_tpm1
  tpm_device_type     = var.tpm_device_type
  boot_steps          = var.boot_steps
  cpu_model           = var.cpu_model

  # CD configuration

  cd_content = {
    "ks.cfg" = templatefile("${path.root}/templates/ks.cfg.pkrtpl", {
      username              = var.ssh_username
      password              = var.ssh_password
      guest_timezone        = var.guest_timezone
      guest_locale          = var.guest_locale
      guest_keyboard_layout = var.guest_keyboard_layout
      ssh_public_key        = data.sshkey.provisioning.public_key
    })
  }
  cd_label = "OEMDRV"

  # Shutdown configuration

  shutdown_command = "echo ${var.ssh_password} | sudo -S bash $XDG_RUNTIME_DIR/shutdown.sh"
  shutdown_timeout = var.shutdown_timeout

  # Communicator configuration

  communicator                 = var.communicator
  pause_before_connecting      = var.pause_before_connecting
  host_port_min                = var.host_port_min
  host_port_max                = var.host_port_max
  skip_nat_mapping             = var.skip_nat_mapping
  ssh_port                     = var.ssh_port
  ssh_username                 = var.ssh_username
  ssh_password                 = var.ssh_password
  ssh_ciphers                  = var.ssh_ciphers
  ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys
  ssh_key_exchange_algorithms  = var.ssh_key_exchange_algorithms
  ssh_certificate_file         = var.ssh_certificate_file
  ssh_pty                      = var.ssh_pty
  ssh_timeout                  = var.ssh_timeout
  ssh_disable_agent_forwarding = var.ssh_disable_agent_forwarding
  ssh_handshake_attempts       = var.ssh_handshake_attempts
  ssh_bastion_host             = var.ssh_bastion_host
  ssh_bastion_port             = var.ssh_bastion_port
  ssh_bastion_agent_auth       = var.ssh_bastion_agent_auth
  ssh_bastion_username         = var.ssh_bastion_username
  ssh_bastion_password         = var.ssh_bastion_password
  ssh_bastion_interactive      = var.ssh_bastion_interactive
  ssh_bastion_private_key_file = var.ssh_bastion_private_key_file
  ssh_bastion_certificate_file = var.ssh_bastion_certificate_file
  ssh_file_transfer_method     = var.ssh_file_transfer_method
  ssh_proxy_host               = var.ssh_proxy_host
  ssh_proxy_port               = var.ssh_proxy_port
  ssh_proxy_username           = var.ssh_proxy_username
  ssh_proxy_password           = var.ssh_proxy_password
  ssh_keep_alive_interval      = var.ssh_keep_alive_interval
  ssh_read_write_timeout       = var.ssh_read_write_timeout
  ssh_remote_tunnels           = var.ssh_remote_tunnels
  ssh_local_tunnels            = var.ssh_local_tunnels
  ssh_private_key_file         = data.sshkey.provisioning.private_key_path

  # Boot Configuration

  disable_vnc            = var.disable_vnc
  boot_key_interval      = var.boot_key_interval
  boot_keygroup_interval = var.boot_keygroup_interval
  boot_wait              = var.boot_wait

  # SMP Configuration

  cpus    = var.cpus
  sockets = var.sockets
  cores   = var.cores
  threads = var.threads
}

build {
  source "source.qemu.rocky9" {
    # ISO Configuration
    iso_url      = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9-latest-x86_64-minimal.iso"
    iso_checksum = "file:https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9-latest-x86_64-minimal.iso.CHECKSUM"

    # EFI Boot Configuration
    efi_boot          = false

    # Boot Configuration
    boot_command = [
      "<up><tab><bs><bs><bs><bs><bs>",
      "inst.text net.ifnames=0",
      "<enter>"
    ]
  }

  # We want to configure the None datasource to set a password on the default
  # cloud user account so that we can at least log into the console when we
  # manually create a VM from the temaplte.
  provisioner "file" {
    content     = templatefile("${path.root}/templates/datasources.cfg.pkrtpl.hcl", {})
    destination = "$XDG_RUNTIME_DIR/datasources.cfg"
  }

  provisioner "shell" {
    inline_shebang = "/bin/bash -e"
    inline = [
      "set -o pipefail",
      "echo '${var.ssh_password}' | sudo -S cp $XDG_RUNTIME_DIR/datasources.cfg /etc/cloud/cloud.cfg.d/datasources.cfg",
    ]
  }

  # By default QEMU Guest Additions does not allow us to execute commands or get
  # the status of executing commands. We want to be able to do this so that the
  # Molecule driver can execute `cloud-init status --wait` to determine that
  # Cloud-init has finished executing.
  # Even with `guest-exec-status` and `guest-exec` enabled, SELinux also
  # prevents the QEMU Guest Agent from executing the command, so we need to
  # enable the `virt_qemu_ga_read_nonsecurity_files` boolean and also install
  # a custom policy to allow it.
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; echo '${var.ssh_password}' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    inline_shebang  = "/bin/bash -ex"
    inline = [
      "set -eo pipefail",
      "cat << EOF > /etc/sysconfig/qemu-ga",
      file("${path.root}/scripts/qemu-ga"),
      "EOF",
      "dnf install -y policycoreutils-python-utils",
      "semanage boolean --modify --on virt_qemu_ga_read_nonsecurity_files",
      "cat << EOF > /run/qemu_guest_agent_cloud_init_module.cil",
      file("${path.root}/scripts/qemu_guest_agent_cloud_init_module.cil"),
      "EOF",
      "semodule -i /run/qemu_guest_agent_cloud_init_module.cil",
      "dnf autoremove -y policycoreutils-python-utils",
    ]
  }

  # Finally, we drop the shutdown script into the XDG_RUNTIME_DIR so that it can
  # perform cleanup in preparation for use as a template, without being included
  # in the final image.
  provisioner "file" {
    source = "${path.root}/scripts/shutdown.sh"
    destination = "$XDG_RUNTIME_DIR/shutdown.sh"
  }
}
