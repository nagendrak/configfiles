#!/bin/bash
set -e

whoami

# Configurable variables
USERNAME=${USERNAME:-devuser}
HOST_UID=${HOST_UID:-1000}
HOST_GID=${HOST_GID:-1000}

# Get current UID/GID of $USERNAME
CURRENT_UID=$(id -u "$USERNAME")
CURRENT_GID=$(id -g "$USERNAME")

# If UID/GID already match, nothing to do
if [ "$CURRENT_UID" -eq "$HOST_UID" ] && [ "$CURRENT_GID" -eq "$HOST_GID" ]; then
    echo "UID/GID already match. No changes needed."
else
    echo "UID/GID mismatch. Syncing to host values..."

    # Check if HOST_UID exists
    if getent passwd "$HOST_UID" > /dev/null; then
        EXISTING_USER=$(getent passwd "$HOST_UID" | cut -d: -f1)
        echo "Deleting existing user with UID $HOST_UID: $EXISTING_USER"
        userdel -r "$EXISTING_USER" || echo "Failed to delete user $EXISTING_USER"
    fi

    # Check if HOST_GID exists
    if getent group "$HOST_GID" > /dev/null; then
        EXISTING_GROUP=$(getent group "$HOST_GID" | cut -d: -f1)
        echo "Deleting existing group with GID $HOST_GID: $EXISTING_GROUP"
        groupdel "$EXISTING_GROUP" || echo "Failed to delete group $EXISTING_GROUP"
    fi

    # Change UID/GID of $USERNAME
    usermod -u "$HOST_UID" "$USERNAME"
    groupmod -g "$HOST_GID" "$USERNAME"

    # Fix ownership of home directory
    chown -R "$HOST_UID:$HOST_GID" "/home/$USERNAME"
fi

export TERM=xterm-256color

# ✅ Switch to user and exec
# exec su-exec "$USERNAME" "$@"
exec gosu "$USERNAME" "$@"

# set -e
#
# USER_ID=${HOST_UID:-1000}
# GROUP_ID=${HOST_GID:-1000}
# echo "Local IDs: $(id -u) $(id -g)"
# echo "Passed IDs: $USER_ID $GROUP_ID"
# USERNAME=devuser
#
# # If host UID/GIDs match with $USERNAME's values, nothing is to be done.
# # If they do not
# #   we check if the host's UID/GID already exists
# #   If it does exist, delete that user/group on the container, and assign
# #   those to $USERNAME
# #   If it does not exist, simply change $USERNAME's UID/GID on the container
# #   to match the host's values
# # Check if UID already exists
#
#
#
# # if id -u "$USER_ID" &>/dev/null; then
# #     echo "UID $USER_ID already exists. Modifying devuser's UID and GID."
# #     usermod -u "$USER_ID" devuser
# #     groupmod -g "$GROUP_ID" devgroup
# # else
# #     groupadd -g "$GROUP_ID" "$USERNAME"
# #     useradd -m -u "$USER_ID" -g "$GROUP_ID" -s /bin/bash "$USERNAME"
# # fi
#
# exec gosu "$USERNAME" "$@"

# set -e
#
# USER_ID=${LOCAL_UID:-1000}
# GROUP_ID=${LOCAL_GID:-1000}
#
# # Update existing devuser to match host UID/GID
# usermod -u "$USER_ID" devuser
# groupmod -g "$GROUP_ID" devuser
#
# # Fix ownership of home and workspace
# chown -R "$USER_ID:$GROUP_ID" /home/devuser || true
# chown -R "$USER_ID:$GROUP_ID" /workspace || true
#
# exec gosu devuser "$@"

# set -e
#
# # If UID/GID env vars are passed, remap devuser
# if [ "$DEV_UID" ] && [ "$DEV_GID" ]; then
#     usermod -u "$DEV_UID" devuser
#     groupmod -g "$DEV_GID" devuser
#     chown -R devuser:devuser /home/devuser
# fi
#
# # Recreate /etc/passwd entry if needed (for dynamic UID)
# if ! getent passwd devuser > /dev/null; then
#     echo "devuser:x:$DEV_UID:$DEV_GID::/home/devuser:/bin/bash" >> /etc/passwd
# fi
#
# chown "$DEV_UID:$DEV_GID" /workspace
#
# # Switch to devuser and exec the command
# exec gosu devuser "$@"
