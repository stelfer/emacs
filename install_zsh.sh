#!/bin/bash
set -uex
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp telfer.zsh-theme ~/.oh-my-zsh/themes/telfer.zsh-theme
perl -p -i -e 's/robbyrussell/telfer/g' ~/.zshrc

