#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! "
echo "##########################################"
echo
echo "Installing Necessary Packages"
echo "#############################"
echo
echo "Native Packages..."
echo
sudo pacman -S --noconfirm --needed sbctl kvantum unzip jq xmlstarlet fastfetch gtk-engine-murrine gtk-engines ttf-hack-nerd ttf-fira-code kdeconnect ttf-terminus-nerd noto-fonts-emoji ttf-meslo-nerd
echo
echo "AUR Packages..."
echo
# Check if yay is installed
if command -v yay &> /dev/null; then
    aur_helper="yay"
# Check if paru is installed
elif command -v paru &> /dev/null; then
    aur_helper="paru"
else
    echo "Neither yay nor paru is installed. Please install one of them."
    exit 1
fi
# Install packages using the detected AUR helper
$aur_helper -S --noconfirm --needed ttf-meslo-nerd-font-powerlevel10k tela-circle-icon-theme-purple archlinux-tweak-tool-git plasma6-applets-window-title
sleep 2
echo
echo "Creating Backup & Applying new Rice, hold on..."
echo "###############################################"
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -Rf Configs/Home/. ~
sudo cp -Rf Configs/System/. / && sudo cp -Rf Configs/Home/. /root/
sleep 2
echo
echo "Adding Fastfetch to your shell configuration"
echo

# Function to add fastfetch to a shell configuration file
add_fastfetch() {
  local shell_rc="$1"

  if ! grep -Fxq 'fastfetch' "$HOME/$shell_rc"; then
    echo '' >> "$HOME/$shell_rc"
    echo 'fastfetch' >> "$HOME/$shell_rc"
    echo
    echo "fastfetch has been added to your $shell_rc and will run on Terminal launch."
  else
    echo "fastfetch is already set to run on Terminal launch in $shell_rc."
  fi
}

# Detect the current shell
current_shell=$(basename "$SHELL")

# Prompt the user
read -p "Do you want to enable fastfetch to run on Terminal launch? (y/n): " response

case "$response" in
  [yY])
    if [ "$current_shell" = "zsh" ]; then
      add_fastfetch ".zshrc"
    elif [ "$current_shell" = "bash" ]; then
      add_fastfetch ".bashrc"
    else
      echo "Unsupported shell: $current_shell"
    fi
    ;;
  [nN])
    echo "fastfetch will not be added to your shell configuration."
    ;;
  *)
    echo "Invalid response. Please enter y or n."
    ;;
esac
sleep 2
echo
echo "Oh-My-Posh Setup."
echo
echo "Installing Oh-My-Posh"
$AUR_HELPER -S --noconfirm --needed oh-my-posh-bin
echo
sleep 3
echo "Injecting OMP to .bashrc"

# Define the lines to be added
line1='# Oh-My-Posh Config'
line2='eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/xero.omp.json)"'

# Define the .bashrc file
bashrc_file="$HOME/.bashrc"

# Function to add lines if not already present
add_lines() {
  if ! grep -qxF "$line1" "$bashrc_file"; then
    echo "" >> "$bashrc_file"  # Add an empty line before line1
    echo "$line1" >> "$bashrc_file"
  fi

  if ! grep -qxF "$line2" "$bashrc_file"; then
    echo "$line2" >> "$bashrc_file"
    echo "" >> "$bashrc_file"  # Add an empty line after line2
  fi
}

# Run the function to add lines
add_lines

echo "Oh-My-Posh injection complete."
sleep 3
echo
# echo "Applying Grub Theme...."
# echo "#######################"
# chmod +x Grub.sh
# sudo ./Grub.sh
# sudo sed -i "s/GRUB_GFXMODE=*.*/GRUB_GFXMODE=1920x1080x32/g" /etc/default/grub
# sudo grub-mkconfig -o /boot/grub/grub.cfg
# sleep 2
echo
echo "Installing Layan Theme"
echo "######################"
echo
cd ~ && git clone https://github.com/vinceliuice/Layan-kde.git && cd Layan-kde/ && sh install.sh
cd ~ && rm -Rf Layan-kde/
sleep 2
echo
echo "Installing & Applying GTK4 Theme "
echo "#################################"
cd ~ && git clone https://github.com/vinceliuice/Layan-gtk-theme.git && cd Layan-gtk-theme/ && sh install.sh -l -c dark -d $HOME/.themes
cd ~ && rm -Rf Layan-gtk-theme/
echo
echo "Plz Reboot To Apply Settings..."
echo "###############################"
echo
echo "Important Links..."
echo "https://wiki.cachyos.org/configuration/secure_boot_setup/"