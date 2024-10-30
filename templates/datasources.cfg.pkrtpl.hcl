datasource_list: ["NoCloud", "None"]
datasource:
  None:
    metadata:
      local-hostname: "localhost.localdomain"
    userdata_raw: |
      #cloud-config
      user:
        lock_passwd: false
        passwd: ${bcrypt("password")}
        shell: /bin/bash
