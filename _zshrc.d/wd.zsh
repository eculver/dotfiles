# ========================================================================
# ZSH conf specific to WD (work) environment
# ========================================================================


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

alias gensampledata='gowd ; cd bin ; ./wd-cli.php -u labs/sampledata/metadata ; ./wd-cli.php -u labs/sampledata/library; ./wd-cli.php -u labs/sampledata/presentations'
alias rmbuildfiles='rm ~/projects/wd-app/resources/*.{js,css}'
alias nummodules='find ~/projects/wd-app/resources/module -name "*.js" | grep -v AppleDouble | wc -l'
alias numwidgets='find ~/projects/wd-app/resources/widget -name "*.js" | grep -v AppleDouble | wc -l'
alias numplugins='find ~/projects/wd-app/resources/plugin -name "*.js" | grep -v AppleDouble | wc -l'
alias update_db_widget='cp /Volumes/eculver/projects/wd-app/resources/widget/draggableBackground/js/draggable-background.js gallery-draggable-background/js'


# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

