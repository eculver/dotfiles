#!/usr/local/bin/zsh
#
# ========================================================================
# Misc utility functions
# ========================================================================

export GO_DEFAULT=hashicorp

# Ping a host, beeping when it comes up
function beepwhenup {
    echo 'Enter host you want to ping:';
    read PHOST;
    [[ "$PHOST" == "" ]] && echo "must enter a host or IP" && return

    while true; do
        ping -c1 -W2 $PHOST 2>&1 >/dev/null
        if [[ "$?" == "0" ]]; then
            for j in $(seq 1 4); do
                say "Host is up";
            done
            ping -c1 $PHOST
            break
        fi
    done
}

# Helper for Github cloning
# deprecated: use goto()
function ghclone {
  local repo=$1
  local dst=$2

  [[ -z "${repo}" ]] && echo "usage: ghclone <repo_pat> [dest]" && return
  [[ -z "${dst}" ]] && dst=$(echo "${repo}" | rev | cut -d '/' -f1 | rev)

  echo "Cloning github.com/${repo} to ${dst}"
  git clone git@github.com:"${repo}" "${dst}"
}

# Print information about a host:port's SSL cert
function sslinfo {
  local domain=$1
  [[ -z "${domain}" ]] && echo "usage: sslinfo <domain>" && return
  echo | openssl s_client -showcerts -servername "${domain}" -connect "${domain}":443 2>/dev/null | openssl x509 -inform pem -noout -text
}

# Go to a <repo> in ~/dev
function goto {
  if hash shopt 2>/dev/null; then
    shopt -s cdspell
  fi

  case $1 in

    */*)
      nav $1
    ;;

    *)
      nav $GO_DEFAULT/$1
    ;;

  esac

  if hash shopt 2>/dev/null; then
    shopt -s cdspell
  fi
}

# The brains behind goto
function nav {
  cd ~/dev/src/github.com/$1 &> /dev/null ||
  clone $1 2> /dev/null ||
  echo "repo @ $1 does not exist"
}

# Checkout <pull-request>
function gcopr {
  git fetch origin pull/$1/head:pr-$1
  git checkout pr-$1
}

# Open the repo in the current directory on github
function gho {
  repo=$(git remote -v)
  re="github.com/([^/]+/[^[:space:]]+)(.git)"
  if [[ $repo =~ $re ]]; then open "https://github.com/${BASH_REMATCH[1]}"; fi
}

# Clone a <repo ...> by "owner/name" into ~/dev
function clone {
  for repo in $@; do
    if [[ "$repo" == */* ]]; then
      local dir=$GOPATH/src/github.com/$repo
      git clone ssh://git@github.com/$repo.git $dir
      cd $dir
    else
      local dir=$GOPATH/src/github.com/$USER_DEFAULT/$repo
      git clone ssh://git@github.com/$USER_DEFAULT/$repo.git $dir
      cd $dir
    fi
  done
}

# Print the current branch name.
function gbn {
  local branch_name="$(                                        \
       git symbolic-ref --quiet --short HEAD 2> /dev/null      \
    || git rev-parse --short HEAD 2> /dev/null                 \
    || echo '(unknown)'                                        \
  )";
  echo $branch_name
}

# Bash completion for goto()
function _goto {
  cur=${COMP_WORDS[COMP_CWORD]}
  if [[ "$cur" =~ ^([^/]+)/(.+)$ ]]; then
    use=`tree -f -L 1 ~/dev/src/github.com/$GO_DEFAULT/ | grep ${BASH_REMATCH[2]} | tr / '\t' | awk '{print $(NF-1),$NF}' | tr ' ' /`
  else
    use=`ls ~/dev/src/github.com/$GO_DEFAULT/ | grep $cur`
  fi
  COMPREPLY=(`compgen -W "$use" -- $cur`)
}

if hash complete 2>/dev/null; then
  complete -o default -o nospace -F _goto goto
fi

# ZSH completion for goto()
function _zsh_goto {
  base=$GOPATH/src/github.com/
  compadd $(find $base -maxdepth 2 -mindepth 2 | sed "s|$base/||")
  compadd $(find $base/$GO_DEFAULT -maxdepth 1 -mindepth 1 | sed "s|$base/$GO_DEFAULT/||")
}

if type compdef &> /dev/null ; then
  compdef _zsh_goto goto
fi


# Notes, worklog etc.
export TXT_HOME=$HOME/sync/txt
export WORKLOG_HOME=$TXT_HOME/worklog
export SUPPORTLOG_HOME=$TXT_HOME/support

function worklog {
    local worklog_file=$1
    local today=$(date +%Y-%m-%d)
    local today_file="$WORKLOG_HOME/${today}_worklog.md"
    local last=$(ls $WORKLOG_HOME | sort -r | head -n1)
    local last_file="$WORKLOG_HOME/${last}"
    local last_log=$(awk '/## Log/,/^$/' ${last_file} | tail -n+2)
    local last_date=$(echo $last | cut -d '_' -f1)
    local last_dow=$(date -j -f %Y-%m-%d $last_date +%A)

    [[ -z "${worklog_file}" ]] && worklog_file="${today_file}"

    if [ ! -f  "${worklog_file}" ]; then
        touch "${worklog_file}"
        (cat <<EOF
# Worklog for ${today}

## Stand-up

### ${last_dow}
${last_log}

### Today
-

## Log
-

EOF
) > "${worklog_file}"
    fi
}

function supportlog {
    local supportlog_file=$1
    local today=$(date +%Y-%m-%d)
    local today_file="$SUPPORTLOG_HOME/${today}_support.md"

    [[ -z "${supportlog_file}" ]] && supportlog_file="${today_file}"

    if [ ! -f  "${supportlog_file}" ]; then
        touch "${supportlog_file}"
        (cat <<EOF
# Support notes for ${today}

## team-tooling
- TOPIC
-- @someone asked...
-- solution:

## atlantis
- TOPIC
-- @someone asked...
-- solution:

## buildkite
- TOPIC
-- @someone asked...
-- solution:

EOF
) > "${supportlog_file}"
    fi
}
