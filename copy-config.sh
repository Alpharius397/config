#!/usr/bin/bash

des=$(realpath ".")
src=$(realpath "$HOME/.config/nvim/lua")

echo "Source: $src"
echo -e "Destination: $des\n"

read -p "Is it correct path [Y/N]: " -r CONFIRM

while [[ $CONFIRM != "Y" && $CONFIRM != "N" ]]; do
	echo -e "Choice must be 'Y' or 'N'\n"
	read -p "Is it correct path [Y/N]: " -r CONFIRM
done

if [[ $CONFIRM == "N" ]]; then
	return
fi

echo "Running command: cp -r ""$src"" ""$des"""

cp -r "$src" "$des"
