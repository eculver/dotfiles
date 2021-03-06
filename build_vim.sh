#!/usr/bin/env bash
#
# Steps for building vim w/ all the features I like
#
# ----------------------------------------------------------------------------
# NOTE(eculver-20161030): Latest versions of vim (7.4.x) don't play nicely
# with the Ruby runtime on MacOS. Specifically, any Ruby command results in a
# segv (segmentation fault). I'm not sure why, what *does* work is using Brew:
#
# 0. Switch to system Ruby first:
# rbenv local system
#
# 1. Use homebrew with the options we want (use --HEAD for latest) 
# brew install vim --with-lua --with-custom-ruby --with-python3 --with-tcl [--HEAD]
# ----------------------------------------------------------------------------

# 0. Install dependencies
# brew/apt-get install lua

# 1. Get/update the code
VIM_HOME=~/src/vim
if [ ! -d "$VIM_HOME" ]; then
    hg clone https://vim.googlecode.com/hg/ $VIM_HOME
else
    cd $VIM_HOME && hg update
fi

# 2. Make sure build env is "clean"
make distclean

# 3. Configure
./configure --prefix=/usr/local --with-features=huge --enable-fail-if-missing \
    --enable-cscope --enable-multibyte \
    --enable-rubyinterp --enable-perlinterp \
    --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config \
    --enable-luainterp=dynamic --with-lua-prefix=/usr/local

# 4. Build
make clean && make

# 3. install
sudo make install
