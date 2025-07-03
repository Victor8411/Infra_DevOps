#!/bin/bash

IPS_JSON=$(terraform output -json vm_ips)

cat <<EOF > hosts.ini
[front]
$(echo "$IPS_JSON" | jq -r '.front') ansible_user=jenkins ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/id_rsa

[back]
$(echo "$IPS_JSON" | jq -r '.back') ansible_user=jenkins ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/id_rsa

[db]
$(echo "$IPS_JSON" | jq -r '.db') ansible_user=jenkins ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/id_rsa
EOF

echo "✅ hosts.ini mis à jour"
