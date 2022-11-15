## VPC Peering

Two Compute Engines with private IPs in two separate VPC in the same project.  
Access over ssh thru [Identity-Aware Proxy](https://cloud.google.com/iap) .  

`vpc1[vm1] <--peering--> vpc2[vm2]`

```
# edit variables.tf before apply !

export GOOGLE_APPLICATION_CREDENTIALS=`realpath <creds>.json`

cd vm1/
terraform init
terraform apply

cd vm2/
terraform init
terraform apply

# variables you will get from outputs above (vpc_id)

cd peering/
terraform init
terraform apply \
-var vm1_network="<vm1_vpc_network_id>" \
-var vm2_network="<vm2_vpc_network_id>"

$ gcloud compute networks peerings list
NAME                                     NETWORK      PEER_PROJECT      PEER_NETWORK  STACK_TYPE  PEER_MTU  IMPORT_CUSTOM_ROUTES  EXPORT_CUSTOM_ROUTES  STATE   STATE_DETAILS
network-peering-vm1-network-vm2-network  vm1-network  <project>         vm2-network                         False                 False                 ACTIVE  [2022-11-15T09:29:27.381-08:00]: Connected.
network-peering-vm2-network-vm1-network  vm2-network  <project>         vm1-network                         False                 False                 ACTIVE  [2022-11-15T09:29:27.381-08:00]: Connected.
```


```
# VM1

$ gcloud compute ssh vm1-vm \
--zone "us-east1-c" \
--tunnel-through-iap \
--project "<project_name>"

demo@vm1-vm:~$ ping -c2 10.20.0.2
PING 10.20.0.2 (10.20.0.2) 56(84) bytes of data.
64 bytes from 10.20.0.2: icmp_seq=1 ttl=64 time=2.39 ms
64 bytes from 10.20.0.2: icmp_seq=2 ttl=64 time=0.291 ms

--- 10.20.0.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.291/1.341/2.392/1.050 ms


# VM2

$ gcloud compute ssh vm2-vm \
--zone "us-east1-c" \
--tunnel-through-iap \
--project "<project_name>"

demo@vm2-vm:~$ ping -c2 10.10.0.2
PING 10.10.0.2 (10.10.0.2) 56(84) bytes of data.
64 bytes from 10.10.0.2: icmp_seq=1 ttl=64 time=1.49 ms
64 bytes from 10.10.0.2: icmp_seq=2 ttl=64 time=0.320 ms

--- 10.10.0.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.320/0.902/1.485/0.582 ms

```