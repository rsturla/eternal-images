#!/usr/bin/env bash

wheelarray=($(getent group wheel | cut -d ":" -f 4 | tr  ',' '\n'))
groups=(docker)

for user in $wheelarray
do
    for group in ${groups[@]}
    do
        usermod -aG $group $user
    done
done
