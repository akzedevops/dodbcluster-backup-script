#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Prompt for the new username
read -p "Enter the new username: " NEW_USERNAME

# Check if the username already exists
if id "$NEW_USERNAME" &>/dev/null; then
    echo "User '$NEW_USERNAME' already exists. Please choose a different username."
    exit 1
fi

# Prompt for the user's full name
read -p "Enter the full name of the user: " FULL_NAME

# Prompt for the user's password
read -s -p "Enter the password for $NEW_USERNAME: " PASSWORD
echo

# Create the new user
useradd -m -c "$FULL_NAME" -G wheel -s /bin/bash "$NEW_USERNAME"

# Set the user's password
echo "$NEW_USERNAME:$PASSWORD" | chpasswd

# Copy the SSH keys from root to the new user
mkdir -p /home/$NEW_USERNAME/.ssh
cp /root/.ssh/authorized_keys /home/$NEW_USERNAME/.ssh/
chown -R $NEW_USERNAME:$NEW_USERNAME /home/$NEW_USERNAME/.ssh

# Add the new user to sudoers with NOPASSWD option
echo "$NEW_USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "User '$NEW_USERNAME' has been created, given sudo permissions (without password), and the SSH key has been copied."
