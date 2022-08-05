kernel starts the init.
---SYSTEMD Made of ---------
smaller programs/services/libraries

-systemctl
-journalctl
-Init
-Process Mgmt
-Network Mgmt (networkd)
-Login Mgmt (logind)
-Logs (journld)

1. Systemd units :
    entity managed by systemd
    i) Service
    ii) Device
    iii) Mountpoint or Automount point
    iv) Swap File
    
 Location ( of unit files ):
  ** Choosing this path : didnt complaint of only having [ ExecStartPre , ExecStart]
  /lib/systemd/system - standard systemd unit files

  /usr/lib/systemd/system - from locally installed packages
  /run/systemd/system - transient unit files
  /etc/systemd/system - all locally configured ( Overwra ites others )

 > sudo su -
 > vi /lib/systemd/system/containerd.service  

 ```
 [Unit]
 Description = A very simple service
 After=network.up.target
 
 [Servicve]
 ExecStart=/usr/local/bin/theprogram
 
 [Install]
 WantedBy=multi-user.target
 ```

 > systemctl daemon-reload  
 > systemctl enable --now containerd  

