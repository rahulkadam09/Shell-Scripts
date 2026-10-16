#!/bin/bash

function usage {
    echo "use c as a argument to create a user"
    echo "use d as a argument to delete a user"
}

function create_user {
    
    read -p "enter username for user :" username
    read -p "enter password for user :" password

    sudo useradd -m $username -p $password  #-m to add home directory for user

    echo "user $username created successfully"
}

function delete_user {
    
    read -p "enter username to delete :" username

    sudo userdel -r $username

    echo "user $username deleted successfully"
}

case "$1" in 
    c)
    echo "creating user"
    create_user
    ;;
    d)
    echo "deleting user"
    delete_user
    ;;
    *)
    usage
    ;;
esac
