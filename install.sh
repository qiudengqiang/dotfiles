#!/bin/bash

bak_dir="$HOME/.dotfiles_bak"
pwd_dir=$(pwd)

function install_dir {
	if [[ ! -d $1 ]]; then
		mkdir -p $1
	fi
	if [[ -n $2 ]]; then
		chmod $2 $1
	fi
}

function install_file {
	src="${pwd_dir}/dotfiles/$1"
	dst="$HOME/$1"
	if [[ -e $dst || -L $dst || -d $dst ]]; then
		mv $dst "${bak_dir}/"
	fi
	ln -s $src $dst

	if [[ -n $2 ]]; then
		chmod $2 ${src}
	fi
}

function ignore_file {
        src="${pwd_dir}/home/$1"
        if [[ -e $src ]]; then
                git update-index --assume-unchanged $src
        fi
}

if [[ -d "$bak_dir" ]]; then
	tmp_dir=$(mktemp -d -t home_XXXXXXXXXX)
	mv $bak_dir $tmp_dir
	echo "move $bak_dir to $tmp_dir"
fi

install_dir $bak_dir
install_dir ~/.config

install_file .bash_profile
install_file .gitconfig
install_file .vimrc
install_file .vim
install_file .config/nvim
