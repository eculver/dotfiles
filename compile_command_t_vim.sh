#!/bin/bash
#
# This is a snip/helper to help remind me how to make the Command-T vim plugin
# work after I have installed it.
#
# Note: the version you build the extension with has to be the same as the version that vim uses.
# So, if you see a message like this:
#
#   command-t.vim could not load the C extension
#   Please see INSTALLATION and TROUBLE-SHOOTING in the help
#   Vim Ruby version: 2.2.5-p319
#   Expected version: 2.1.1-p76
#   For more information type:    :help command-t
#
# This means, vim is using 2.2.5 and the extension was built for 2.1.1.
# To fix this, make sure you activate the correct ruby version with rbenv or
# whatever way makes sense at the time -- the first time I ran this, I had
# to switch to ruby 2.2.5 because I had built vim with 2.2.5 ruby bindings.
# So, to fix, run:
#
# rbenv use 2.2.5
#
# Then run this command.
#
# Update: the script should take care of detecting and building against the
# correct version of ruby, so hopefully this isn't an issue.
#
# If all else fails, do :help command-t and search for 'command-t-compile'
#
##############################################################################

INSTALL_DIR=~/.vim/bundle/command-t
PLUGIN_RUBY_DIR="${INSTALL_DIR}/ruby/command-t"
CWD=$(pwd)

VIM_RUBY_VERSION=$(vim --version | grep rbenv | awk '{print $4}' | cut -d '/' -f6)

if [[ "${VIM_RUBY_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "${VIM_RUBY_VERSION}" >> ${PLUGIN_RUBY_DIR}/.ruby-version
else
    echo "Invalid ruby version found: ${VIM_RUBY_VERSION}"
    echo "Could not determine ruby version linked to vim -- this might fail, see docstring in this script"
fi

cd $PLUGIN_RUBY_DIR && ruby extconf.rb && make

[[ $? == 0 ]] && echo "Success" || "Fail :("

cd $CWD
