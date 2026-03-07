#!/usr/bin/env bash

# $1 - name of user
# $2 - days of certificate expiration
# $3 - root cerifcate path
# $4 - root certificate key path
create_key_and_csr() {
    echo "create user $1"
    mkdir $1
    openssl genrsa -out $1/$1.key 2048
    openssl req \
        -new \
        -key $1/$1.key \
        -out $1/$1.csr \
        -subj "/CN=$1/O=propdevelopment"
    openssl x509 \
        -req \
        -in $1/$1.csr \
        -CA $3 \
        -CAkey $4 \
        -CAcreateserial \
        -out $1/$1.crt \
        -days $2
}

for (( i = 0; i < 4; i++ ))
do
    user=user-$(printf "%03d" $i)
    create_key_and_csr $user 500 ~/.minikube/ca.crt ~/.minikube/ca.key
    kubectl config set-credentials $user \
        --client-certificate=$user/$user.crt \
        --client-key=$user/$user.key
    kubectl config set-context $user-context \
        --cluster=minikube \
        --user=$user
done
