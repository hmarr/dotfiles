#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Need to be root to set hostname, re-run with sudo"
  exit 1
fi

new_hostname="$1"
echo "Set hostname to '$new_hostname'?"
select yn in "Yes" "No"; do
  case $yn in
    Yes )  break;;
    No ) exit;;
  esac
done

scutil --set ComputerName "$new_hostname"
scutil --set HostName "$new_hostname"
scutil --set LocalHostName "$new_hostname"

echo "Done! Restart for the change to fully take effect."
