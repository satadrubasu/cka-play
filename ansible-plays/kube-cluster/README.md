## Usage

|Step #|Details|
|---|---|
|Step 1|Configure the detals of the target host on file ./host_vars/target_pats|
|Step 2|run command - ansible-playbook site.yml|
   
 > ansible-playbook site.yml


### EC2 details ?

1. EC2 type t3.2xlarge [ 8 vcpu - 32gb ram ] 
2. Base AMI - ubuntu-bionic-18.04
3. Role - patsvm
    Should have access to download from s3 bucket location for CNPats softwares
    Should have access to CodeCommit
    AWSCodeCommitReadOnly , AmazonS3ReadonlyAccess , AmazonVPCReadOnlyAccess , AmazonEC2FullAccess 


### Troubleshoot

Wednesday 24 November 2021  19:12:50 +0530 (0:01:04.299)       0:05:56.372 **** 
fatal: [target_pats]: FAILED! => {"changed": false, "dest": "/root/pats/", "extract_results": {"cmd": ["/bin/tar", "--extract", "-C", "/root/pats/", "-z", "-f", "/root/pats/pats.2021.04.m0.i7.SSA.tgz"], "err": "/bin/tar: ./pats.2021.04.m0.i7.tar: Wrote only 512 of 10240 bytes\n/bin/tar: Exiting with failure status due to previous errors\n", "out": "", "rc": 2}, "gid": 25, "group": "floppy", "handler": "TgzArchive", "mode": "0700", "msg": "failed to unpack /root/pats/pats.2021.04.m0.i7.SSA.tgz to /root/pats/", "owner": "908551", "size": 4096, "src": "/root/pats/pats.2021.04.m0.i7.SSA.tgz", "state": "directory", "uid": 908551}

