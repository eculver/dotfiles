#!/usr/bin/env bash

# Steps for building vim w/ all the features I like

# 0. Install mercurial
# brew/apt-get install mercurial

# 1. Get/update the code
VIM_HOME=~/dev/vim
if [ ! -d "$VIM_HOME" ]; then
    hg clone https://vim.googlecode.com/hg/ $VIM_HOME
else
    cd $VIM_HOME && hg update
fi

# 2. Configure
./configure --prefix=/usr/local --with-features=huge --enable-fail-if-missing \
    --enable-cscope --enable-multibyte --enable-tclinterp \
    --enable-rubyinterp --enable-perlinterp \
    --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config \
    --enable-luainterp=dynamic --with-lua-prefix=/usr

# 3. Build
make clean && make

# 4. install
sudo make install
