# ========================================================================
# ZSH conf specific to WD (work) environment
# ========================================================================

# because history is hard on i/o and because our environments are virtualized
# having a large history becomes a big terd for performance, so set it to
# something small and use a simple cron script for saving history out of band
export HISTSIZE=1000
export SAVEHIST=1000

# for various apps like vim to display correctly
export LANG=en_US.UTF-8

# ------------------------------------------------------------------------
# Virtualenv
# ------------------------------------------------------------------------

export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export VIRTUALENVWRAPPER_LOG_DIR=$WORKON_HOME
export VIRTUALENVWRAPPER_HOOK_DIR=$WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

alias gensampledata='gowd ; cd bin ; ./wd-cli.php -u labs/sampledata/metadata ; ./wd-cli.php -u labs/sampledata/library; ./wd-cli.php -u labs/sampledata/presentations'
alias rmdotunder='find . -type f -name "._*" -exec rm -f {} \; -print'
alias rmbuildfiles='rm ~/projects/wd-app/resources/*.{js,css}'
alias nummodules='find ~/projects/wd-app/resources/module -name "*.js" | grep -v AppleDouble | wc -l'
alias numwidgets='find ~/projects/wd-app/resources/widget -name "*.js" | grep -v AppleDouble | wc -l'
alias numplugins='find ~/projects/wd-app/resources/plugin -name "*.js" | grep -v AppleDouble | wc -l'
alias update_db_widget='cp /Volumes/eculver/projects/wd-app/resources/widget/draggableBackground/js/draggable-background.js gallery-draggable-background/js'

alias gowd='cd ~/projects/wd-app'
alias gowdl='cd ~/projects/wd-legacy'
alias gotest='cd ~/projects/wd-legacy/resource/wd/web/test'
alias gomodel='cd ~/projects/wd-legacy/resource/wd/web/pkg/model'
alias goview='cd ~/projects/wd-legacy/resource/wd/web/pkg/view'
alias gocontroller='cd ~/projects/wd-legacy/resource/wd/web/pkg/controller'

alias exclude_svn='grep -v "/\.svn/"'
alias svn_st='rmdotunder&&svn st'

alias buildconf='time ~/projects/wd-legacy/bin/build-config local'
alias buildwd='time ~/projects/wd-legacy/bin/build-resources -v'
alias buildrt='time ~/projects/wd-legacy/bin/build-resource-tree'

alias docwd='yuidoc --server 8080 resource/wd/web/pkg/model'
alias testwd='jsautotest --config ~/projects/wd-legacy/resource/jstd.conf'
alias capture='java -jar ~/bin/jstd/JsTestDriver-1.3.4.b.jar --config ~/projects/wd-legacy/resource/jstd.conf --port 4224 --runnerMode DEBUG'
alias resetclients='java -jar ~/bin/jstd/JsTestDriver-1.3.4.b.jar --config ~/projects/wd-legacy/resource/jstd.conf --runnerMode DEBUG --reset'

# git fu
alias rmrctags='git tag | grep -e "\.rc$" | xargs -p -I {} git push origin :refs/tags/{} && git tag -l | xargs git tag -d && git fetch --tags'

# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

merged () {
    for branch in $(git branch -a | grep remotes | grep $1 | cut -f 3- -d /); do is-merged.sh $branch; done
}

goie () {
    CONF=/Users/evan/projects/wd-legacy/app/config/config.php
    EXT=.bak

    if [[ ! -e ${CONF}${EXT} ]] then
        sed -i $EXT -e "s/'is\-build' => false/'is-build' => true/g" $CONF
        buildwd
    else
        echo "already in IE mode?\n"
    fi
}

noie () {
    CONF=/Users/evan/projects/wd-legacy/app/config/config.php
    EXT=.bak

    if [[ -e ${CONF}${EXT} ]] then
        mv ${CONF}{${EXT},}
    else
        echo "not in IE mode?\n"
    fi
}

