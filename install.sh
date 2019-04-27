#!/usr/bin/env bash
gclone() {
    git clone --depth=1 https://github.com/paperbenni/"$1".git
}

mkdir -p ~/.local/share/fonts

pushd ~/.local/share/fonts
if ! [ -e monaco.ttf ]; then
    wget https://github.com/todylu/monaco.ttf/raw/master/monaco.ttf
fi
popd

rm -rf ~/suckless
mkdir ~/suckless
cd ~/suckless

gclone dwm
gclone dmenu

command -v pacman && sudo pacman -S --noconfirm i3lock
command -v apt-get && sudo apt install -y i3lock

sudo curl "https://raw.githubusercontent.com/paperbenni/slock/master/slock" > /usr/bin/slock
sudo chmod +x /usr/bin/slock

gclone st
wget https://raw.githubusercontent.com/paperbenni/suckless/master/dwm.desktop
sudo mv dwm.desktop /usr/share/xsessions/

for FOLDER in ./*; do
    if ! [ -d "$FOLDER" ]; then
        echo "skipping $FOLDER"
        continue
    fi
    pushd "$FOLDER"
    rm config.h
    make
    sudo make install
    popd
done

if ! [ -z "$1" ]; then
    curl https://raw.githubusercontent.com/paperbenni/dotfiles/master/install.sh | bash
fi
