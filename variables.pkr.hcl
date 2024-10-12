# Qemu Specific Configuration

variable "iso_skip_cache" {
  type        = bool
  description = "Use iso from provided url. Qemu must support curl block device. This defaults to false."
  default     = null
}

variable "accelerator" {
  type        = string
  description = "The accelerator type to use when running the VM. This may be none, kvm, tcg, hax, hvf, whpx, or xen. The appropriate software must have already been installed on your build machine to use the accelerator you specified. When no accelerator is specified, Packer will try to use kvm if it is available but will default to tcg otherwise."
  default     = null
}

variable "disk_additional_size" {
  type        = list(string)
  description = "Additional disks to create. Uses vm_name as the disk name template and appends -# where # is the position in the array. # starts at 1 since 0 is the default disk. Each string represents the disk image size in bytes. Optional suffixes 'k' or 'K' (kilobyte, 1024), 'M' (megabyte, 1024k), 'G' (gigabyte, 1024M), 'T' (terabyte, 1024G), 'P' (petabyte, 1024T) and 'E' (exabyte, 1024P) are supported. 'b' is ignored. Per qemu-img documentation. Each additional disk uses the same disk parameters as the default disk. Unset by default."
  default     = null
}

variable "firmware" {
  type        = string
  description = "The firmware file to be used by QEMU. If unset, QEMU will load its default firmware. Also see the QEMU documentation."
  default     = null
}

variable "use_pflash" {
  type        = bool
  description = "If a firmware file option was provided, this option can be used to change how qemu will get it. If false (the default), then the firmware is provided through the -bios option, but if true, a pflash drive will be used instead."
  default     = null
}

variable "disk_interface" {
  type        = string
  description = "The interface to use for the disk. Allowed values include any of ide, sata, scsi, virtio or virtio-scsi^*. Note also that any boot commands or kickstart type scripts must have proper adjustments for resulting device names. The Qemu builder uses virtio by default."
  default     = null
}

variable "disk_size" {
  type        = string
  description = "The size in bytes of the hard disk of the VM. Suffix with the first letter of common byte types. Use \"k\" or \"K\" for kilobytes, \"M\" for megabytes, G for gigabytes, and T for terabytes. If no value is provided for disk_size, Packer uses a default of 40960M (40 GB). If a disk_size number is provided with no units, Packer will default to Megabytes."
  default     = null
}

variable "skip_resize_disk" {
  type        = bool
  description = "Packer resizes the QCOW2 image using qemu-img resize. Set this option to true to disable resizing. Defaults to false."
  default     = null
}

variable "disk_cache" {
  type        = string
  description = "The cache mode to use for disk. Allowed values include any of writethrough, writeback, none, unsafe or directsync. By default, this is set to writeback."
  default     = null
}

variable "disk_discard" {
  type        = string
  description = "The discard mode to use for disk. Allowed values include any of unmap or ignore. By default, this is set to ignore."
  default     = null
}

variable "disk_detect_zeroes" {
  type        = string
  description = "The detect-zeroes mode to use for disk. Allowed values include any of unmap, on or off. Defaults to off. When the value is \"off\" we don't set the flag in the qemu command, so that Packer still works with old versions of QEMU that don't have this option."
  default     = null
}

variable "skip_compaction" {
  type        = bool
  description = "Packer compacts the QCOW2 image using qemu-img convert. Set this option to true to disable compacting. Defaults to false."
  default     = null
}

variable "disk_compression" {
  type        = bool
  description = "Apply compression to the QCOW2 disk file using qemu-img convert. Defaults to false."
  default     = null
}

variable "format" {
  type        = string
  description = "Either qcow2 or raw, this specifies the output format of the virtual machine image. This defaults to qcow2. Due to a long-standing bug with qemu-img convert on OSX, sometimes the qemu-img convert call will create a corrupted image. If this is an issue for you, make sure that the the output format matches the input file's format, and Packer will perform a simple copy operation instead. See https://bugs.launchpad.net/qemu/+bug/1776920 for more details."
  default     = null
}

variable "headless" {
  type        = bool
  description = "Packer defaults to building QEMU virtual machines by launching a GUI that shows the console of the machine being built. When this value is set to true, the machine will start without a console."
  default     = null
}

variable "disk_image" {
  type        = bool
  description = "Packer defaults to building from an ISO file, this parameter controls whether the ISO URL supplied is actually a bootable QEMU image. When this value is set to true, the machine will either clone the source or use it as a backing file (if use_backing_file is true); then, it will resize the image according to disk_size and boot it."
  default     = null
}

variable "use_backing_file" {
  type        = bool
  description = "Only applicable when disk_image is true and format is qcow2, set this option to true to create a new QCOW2 file that uses the file located at iso_url as a backing file. The new file will only contain blocks that have changed compared to the backing file, so enabling this option can significantly reduce disk usage. If true, Packer will force the skip_compaction also to be true as well to skip disk conversion which would render the backing file feature useless."
  default     = null
}

variable "machine_type" {
  type        = string
  description = "The type of machine emulation to use. Run your qemu binary with the flags -machine help to list available types for your system. This defaults to pc."
  default     = null
}

variable "memory" {
  type        = number
  description = "The amount of memory to use when building the VM in megabytes. This defaults to 512 megabytes."
  default     = null
}

variable "net_device" {
  type        = string
  description = "The driver to use for the network interface. Allowed values ne2k_pci, i82551, i82557b, i82559er, rtl8139, e1000, pcnet, virtio, virtio-net, virtio-net-pci, usb-net, i82559a, i82559b, i82559c, i82550, i82562, i82557a, i82557c, i82801, vmxnet3, i82558a or i82558b. The Qemu builder uses virtio-net by default."
  default     = null
}

variable "net_bridge" {
  type        = string
  description = "Connects the network to this bridge instead of using the user mode networking."
  default     = null
}

variable "output_directory" {
  type        = string
  description = "This is the path to the directory where the resulting virtual machine will be created. This may be relative or absolute. If relative, the path is relative to the working directory when packer is executed. This directory must not exist or be empty prior to running the builder. By default this is output-BUILDNAME where \"BUILDNAME\" is the name of the build."
  default     = null
}

variable "qemuargs" {
  type        = list(list(string))
  description = "Allows complete control over the qemu command line (though not qemu-img). Each array of strings makes up a command line switch that overrides matching default switch/value pairs. Any value specified as an empty string is ignored. All values after the switch are concatenated with no separator."
  default     = null
}

variable "qemu_img_args" {
  type        = map(list(string))
  description = "A map of custom arguments to pass to qemu-img commands, where the key is the subcommand, and the values are lists of strings for each flag."
  default     = null
}

variable "qemu_binary" {
  type        = string
  description = "The name of the Qemu binary to look for. This defaults to qemu-system-x86_64, but may need to be changed for some platforms. For example qemu-kvm, or qemu-system-i386 may be a better choice for some systems."
  default     = null
}

variable "qmp_enable" {
  type        = bool
  description = "Enable QMP socket. Location is specified by qmp_socket_path. Defaults to false."
  default     = null
}

variable "qmp_socket_path" {
  type        = string
  description = "QMP Socket Path when qmp_enable is true. Defaults to output_directory/vm_name.monitor."
  default     = null
}

variable "use_default_display" {
  type        = bool
  description = "If true, do not pass a -display option to qemu, allowing it to choose the default. This may be needed when running under macOS, and getting errors about sdl not being available."
  default     = null
}

variable "vga" {
  type        = string
  description = "The type of VGA card to emulate. If undefined, this will not be included in the command-line, and the default qemu value for the emulated machine will be picked."
  default     = null
}

variable "display" {
  type        = string
  description = "What QEMU -display option to use. Defaults to gtk, use none to not pass the -display option allowing QEMU to choose the default. This may be needed when running under macOS, and getting errors about sdl not being available."
  default     = null
}

variable "vnc_bind_address" {
  type        = string
  description = "The IP address that should be binded to for VNC. By default packer will use 127.0.0.1 for this. If you wish to bind to all interfaces use 0.0.0.0."
  default     = null
}

variable "vnc_use_password" {
  type        = bool
  description = "Whether or not to set a password on the VNC server. This option automatically enables the QMP socket. See qmp_socket_path. Defaults to false."
  default     = null
}

variable "vnc_port_min" {
  type        = number
  description = "The minimum and maximum port to use for VNC access to the virtual machine. The builder uses VNC to type the initial boot_command. Because Packer generally runs in parallel, Packer uses a randomly chosen port in this range that appears available. By default this is 5900 to 6000. The minimum and maximum ports are inclusive. The minimum port cannot be set below 5900 due to a quirk in how QEMU parses vnc display address."
  default     = null
}

variable "vnc_port_max" {
  type        = number
  description = "VNC Port Max"
  default     = null
}

variable "vm_name" {
  type        = string
  description = "This is the name of the image (QCOW2 or IMG) file for the new virtual machine. By default this is packer-BUILDNAME, where \"BUILDNAME\" is the name of the build. Currently, no file extension will be used unless it is specified in this option."
  default     = null
}

variable "cdrom_interface" {
  type        = string
  description = "The interface to use for the CDROM device which contains the ISO image. Allowed values include any of ide, scsi, virtio or virtio-scsi. The Qemu builder uses virtio by default. Some ARM64 images require virtio-scsi."
  default     = null
}

variable "vtpm" {
  type        = bool
  description = "Use a virtual (emulated) TPM device to expose to the VM."
  default     = null
}

variable "use_tpm1" {
  type        = bool
  description = "Use version 1.2 of the TPM specification for the emulated TPM."
  default     = null
}

variable "tpm_device_type" {
  type        = string
  description = "The TPM device type to inject in the qemu command-line"
  default     = null
}

variable "boot_steps" {
  type        = list(list(string))
  description = "This is an array of tuples of boot commands, to type when the virtual machine is booted. The first element of the tuple is the actual boot command. The second element of the tuple, which is optional, is a description of what the boot command does. This is intended to be used for interactive installers that requires many commands to complete the installation. Both the command and the description will be printed when logging is enabled. When debug mode is enabled Packer will pause after typing each boot command. This will make it easier to follow along the installation process and make sure the Packer and the installer are in sync. boot_steps and boot_commands are mutually exclusive."
  default     = null
}

variable "cpu_model" {
  type        = string
  description = "The CPU model is what will be used by qemu for booting the virtual machine and determine which features of a specific model/family of processors is supported."
  default     = null
}

# Shutdown configuration

variable "shutdown_timeout" {
  type        = string
  description = "The amount of time to wait after executing the shutdown_command for the virtual machine to actually shut down. If the machine doesn't shut down in this time it is considered an error. Example: \"1h5m2s\". By default, the time out is \"5m\" (five minutes)."
  default     = null
}

# Communicator configuration

variable "communicator" {
  type        = string
  description = "Packer currently supports three kinds of communicators: \"none\" - No communicator will be used. If this is set, most provisioners also can't be used. \"ssh\" - An SSH connection will be established to the machine. This is usually the default. \"winrm\" - A WinRM connection will be established. In addition, some builders have custom communicators they can use. For example, the Docker builder has a \"docker\" communicator that uses docker exec and docker cp to execute scripts and copy files."
  default     = null
}

variable "pause_before_connecting" {
  type        = string
  description = "We recommend that you enable SSH or WinRM as the very last step in your guest's bootstrap script, but sometimes you may have a race condition where you need Packer to wait before attempting to connect to your guest. Example: \"1h5m2s\"."
  default     = null
}

variable "host_port_min" {
  type        = number
  description = "The minimum port to use for the Communicator port on the host machine which is forwarded to the SSH or WinRM port on the guest machine. By default this is 2222."
  default     = null
}

variable "host_port_max" {
  type        = number
  description = "The maximum port to use for the Communicator port on the host machine which is forwarded to the SSH or WinRM port on the guest machine. Because Packer often runs in parallel, Packer will choose a randomly available port in this range to use as the host port. By default this is 4444."
  default     = null
}

variable "skip_nat_mapping" {
  type        = bool
  description = "Defaults to false. When enabled, Packer does not setup forwarded port mapping for communicator (SSH or WinRM) requests and uses ssh_port or winrm_port on the host to communicate to the virtual machine."
  default     = null
}


variable "ssh_port" {
  type        = number
  description = "The port to connect to SSH. This defaults to 22."
  default     = null
}

variable "ssh_username" {
  type        = string
  description = "The username to connect to SSH with. Required if using SSH."
  default     = null
}

variable "ssh_password" {
  type        = string
  description = "A plaintext password to use to authenticate with SSH."
  default     = null
}

variable "ssh_ciphers" {
  type        = list(string)
  description = "This overrides the value of ciphers supported by default by Golang. The default value is [ \"aes128-gcm@openssh.com\", \"chacha20-poly1305@openssh.com\", \"aes128-ctr\", \"aes192-ctr\", \"aes256-ctr\", ]"
  default     = null
}

variable "ssh_clear_authorized_keys" {
  type        = bool
  description = "If true, Packer will attempt to remove its temporary key from ~/.ssh/authorized_keys and /root/.ssh/authorized_keys. This is a mostly cosmetic option, since Packer will delete the temporary private key from the host system regardless of whether this is set to true (unless the user has set the -debug flag). Defaults to \"false\"; currently only works on guests with sed installed."
  default     = null
}

variable "ssh_key_exchange_algorithms" {
  type        = list(string)
  description = "If set, Packer will override the value of key exchange (kex) algorithms supported by default by Golang. Acceptable values include: \"curve25519-sha256@libssh.org\", \"ecdh-sha2-nistp256\", \"ecdh-sha2-nistp384\", \"ecdh-sha2-nistp521\", \"diffie-hellman-group14-sha1\", and \"diffie-hellman-group1-sha1\"."
  default     = null
}

variable "ssh_certificate_file" {
  type        = string
  description = "Path to user certificate used to authenticate with SSH. The ~ can be used in path and will be expanded to the home directory of current user."
  default     = null
}

variable "ssh_pty" {
  type        = bool
  description = "If true, a PTY will be requested for the SSH connection. This defaults to false."
  default     = null
}

variable "ssh_timeout" {
  type        = string
  description = "The time to wait for SSH to become available. Packer uses this to determine when the machine has booted so this is usually quite long. Example value: 10m. This defaults to 5m, unless ssh_handshake_attempts is set."
  default     = null
}

variable "ssh_disable_agent_forwarding" {
  type        = bool
  description = "If true, SSH agent forwarding will be disabled. Defaults to false."
  default     = null
}

variable "ssh_handshake_attempts" {
  type        = number
  description = "The number of handshakes to attempt with SSH once it can connect. This defaults to 10, unless a ssh_timeout is set."
  default     = null
}

variable "ssh_bastion_host" {
  type        = string
  description = "A bastion host to use for the actual SSH connection."
  default     = null
}

variable "ssh_bastion_port" {
  type        = number
  description = "The port of the bastion host. Defaults to 22."
  default     = null
}

variable "ssh_bastion_agent_auth" {
  type        = bool
  description = "If true, the local SSH agent will be used to authenticate with the bastion host. Defaults to false."
  default     = null
}

variable "ssh_bastion_username" {
  type        = string
  description = "The username to connect to the bastion host."
  default     = null
}

variable "ssh_bastion_password" {
  type        = string
  description = "The password to use to authenticate with the bastion host."
  default     = null
}

variable "ssh_bastion_interactive" {
  type        = bool
  description = "If true, the keyboard-interactive used to authenticate with bastion host."
  default     = null
}

variable "ssh_bastion_private_key_file" {
  type        = string
  description = "Path to a PEM encoded private key file to use to authenticate with the bastion host. The ~ can be used in path and will be expanded to the home directory of current user."
  default     = null
}

variable "ssh_bastion_certificate_file" {
  type        = string
  description = "Path to user certificate used to authenticate with bastion host. The ~ can be used in path and will be expanded to the home directory of current user."
  default     = null
}

variable "ssh_file_transfer_method" {
  type        = string
  description = "scp or sftp - How to transfer files, Secure copy (default) or SSH File Transfer Protocol."
  default     = null
}

variable "ssh_proxy_host" {
  type        = string
  description = "A SOCKS proxy host to use for SSH connection"
  default     = null
}

variable "ssh_proxy_port" {
  type        = number
  description = "A port of the SOCKS proxy. Defaults to 1080."
  default     = null
}

variable "ssh_proxy_username" {
  type        = string
  description = "The optional username to authenticate with the proxy server."
  default     = null
}

variable "ssh_proxy_password" {
  type        = string
  description = "The optional password to use to authenticate with the proxy server."
  default     = null
}

variable "ssh_keep_alive_interval" {
  type        = string
  description = "How often to send \"keep alive\" messages to the server. Set to a negative value (-1s) to disable. Example value: 10s. Defaults to 5s."
  default     = null
}

variable "ssh_read_write_timeout" {
  type        = string
  description = "The amount of time to wait for a remote command to end. This might be useful if, for example, packer hangs on a connection after a reboot. Example: 5m. Disabled by default."
  default     = null
}

variable "ssh_remote_tunnels" {
  type        = list(string)
  description = ""
  default     = null
}

variable "ssh_local_tunnels" {
  type        = list(string)
  description = ""
  default     = null
}

# Boot Configuration

variable "disable_vnc" {
  type        = bool
  description = "Whether to create a VNC connection or not. A boot_command cannot be used when this is true. Defaults to false."
  default     = null
}

variable "boot_key_interval" {
  type        = string
  description = "Time in ms to wait between each key press"
  default     = null
}

variable "boot_keygroup_interval" {
  type        = string
  description = "Time to wait after sending a group of key pressses. The value of this should be a duration. Examples are 5s and 1m30s which will cause Packer to wait five seconds and one minute 30 seconds, respectively. If this isn't specified, a sensible default value is picked depending on the builder type."
  default     = null
}

variable "boot_wait" {
  type        = string
  description = "The time to wait after booting the initial virtual machine before typing the boot_command. The value of this should be a duration. Examples are 5s and 1m30s which will cause Packer to wait five seconds and one minute 30 seconds, respectively. If this isn't specified, the default is 10s or 10 seconds. To set boot_wait to 0s, use a negative number, such as \"-1s\""
  default     = null
}

# SMP Configuration

variable "cpus" {
  type        = number
  description = "The number of virtual cpus to use when building the VM."
  default     = null
}

variable "sockets" {
  type        = number
  description = "The number of sockets to use when building the VM. The default is 1 socket. The socket count must not be higher than the CPU count."
  default     = null
}

variable "cores" {
  type        = number
  description = "The number of cores per CPU to use when building the VM. The default is 1 core per CPU."
  default     = null
}

variable "threads" {
  type        = number
  description = "The number of threads per core to use when building the VM. The default is 1 thread per core."
  default     = null
}

# Guest OS Configuration

variable "guest_timezone" {
  type        = string
  description = "The timezone for the installed guest operating system"
  default     = "UTC"
}

variable "guest_locale" {
  type        = string
  description = "The locale for the installed guest operating system"
  default     = env("LANG")
}

variable "guest_keyboard_layout" {
  type        = string
  description = "The keyboard layout for the installed guest operating system"
  default     = "us"
}
