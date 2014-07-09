#!/usr/bin/env bash

__powerline() {

    # Unicode symbols
    PS_SYMBOL_DARWIN=''
    PS_SYMBOL_LINUX='$'
    PS_SYMBOL_OTHER='%'
    GIT_BRANCH_SYMBOL='⑂ '
    GIT_BRANCH_CHANGED_SYMBOL='+'
    GIT_NEED_PUSH_SYMBOL='⇡'
    GIT_NEED_PULL_SYMBOL='⇣'

    SEPARATOR_RIGHT=''

    # Solarized colorscheme
    FG_BASE03="\[$(tput setaf 8)\]"
    FG_BASE02="\[$(tput setaf 0)\]"
    FG_BASE01="\[$(tput setaf 10)\]"
    FG_BASE00="\[$(tput setaf 11)\]"
    FG_BASE0="\[$(tput setaf 12)\]"
    FG_BASE1="\[$(tput setaf 14)\]"
    FG_BASE2="\[$(tput setaf 7)\]"
    FG_BASE3="\[$(tput setaf 15)\]"

    BG_BASE03="\[$(tput setab 8)\]"
    BG_BASE02="\[$(tput setab 0)\]"
    BG_BASE01="\[$(tput setab 10)\]"
    BG_BASE00="\[$(tput setab 11)\]"
    BG_BASE0="\[$(tput setab 12)\]"
    BG_BASE1="\[$(tput setab 14)\]"
    BG_BASE2="\[$(tput setab 7)\]"
    BG_BASE3="\[$(tput setab 15)\]"

    FG_YELLOW="\[$(tput setaf 227)\]"
    FG_ORANGE="\[$(tput setaf 208)\]"
    FG_RED="\[$(tput setaf 124)\]"
    FG_MAGENTA="\[$(tput setaf 54)\]"
    FG_VIOLET="\[$(tput setaf 63)\]"
    FG_BLUE="\[$(tput setaf 26)\]"
    FG_CYAN="\[$(tput setaf 38)\]"
    FG_GREEN="\[$(tput setaf 28)\]"
    FG_DARK="\[$(tput setaf 254)\]"
    FG_REALDARK="\[$(tput setaf 15)\]"

    FG_DARK_SEP="\[$(tput setaf 236)\]"
    FG_EXIT_SEP="\[$(tput setaf 220)\]"

    BG_YELLOW="\[$(tput setab 227)\]"
    BG_ORANGE="\[$(tput setab 208)\]"
    BG_RED="\[$(tput setab 88)\]"
    BG_MAGENTA="\[$(tput setab 54)\]"
    BG_VIOLET="\[$(tput setab 63)\]"
    BG_BLUE="\[$(tput setab 26)\]"
    BG_CYAN="\[$(tput setab 38)\]"
    BG_GREEN="\[$(tput setab 29)\]"
    BG_DARK="\[$(tput setab 236)\]"
    BG_REALDARK="\[$(tput setab 232)\]"

    DIM="\[$(tput dim)\]"
    REVERSE="\[$(tput rev)\]"
    RESET="\[$(tput sgr0)\]"
    BOLD="\[$(tput bold)\]"

    __set_sep_color() {
        [ -z "$(which git)" ] && return    # no git command found

        # try to get current branch or or SHA1 hash for detached head
        local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
        if [ -z "$branch" ]; then 
            FG_EXIT_SEP=$FG_DARK_SEP
            return
        fi

        FG_EXIT_SEP=$FG_BLUE

    }

    __git_branch() { 
        [ -z "$(which git)" ] && return    # no git command found

        # try to get current branch or or SHA1 hash for detached head
        local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
        [ -z "$branch" ] && return

        local marks

        # branch is modified
        [ -n "$(git status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

        # check if local branch is ahead/behind of remote and by how many commits
        # Shamelessly copied from http://stackoverflow.com/questions/2969214/git-programmatically-know-by-how-much-the-branch-is-ahead-behind-a-remote-branc
        local remote="$(git config branch.$branch.remote)"
        local remote_ref="$(git config branch.$branch.merge)"
        local remote_branch="${remote_ref##refs/heads/}"
        local tracking_branch="refs/remotes/$remote/$remote_branch"
        if [ -n "$remote" ]; then
            local pushN="$(git rev-list $tracking_branch..HEAD|wc -l|tr -d ' ')"
            local pullN="$(git rev-list HEAD..$tracking_branch|wc -l|tr -d ' ')"
            [ "$pushN" != "0" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$pushN"
            [ "$pullN" != "0" ] && marks+=" $GIT_NEED_PULL_SYMBOL$pullN"
        fi

        # print the git branch segment without a trailing newline
        printf "$BG_BLUE$FG_DARK_SEP$SEPARATOR_RIGHT"
        printf " $BG_BLUE$FG_DARK$GIT_BRANCH_SYMBOL$branch$marks "
    }

    case "$(uname)" in
        Darwin)
            PS_SYMBOL=$PS_SYMBOL_DARWIN
            ;;
        Linux)
            PS_SYMBOL=$PS_SYMBOL_LINUX
            ;;
        *)
            PS_SYMBOL=$PS_SYMBOL_OTHER
    esac

    __set_virtualenv () {
      if test -z "$VIRTUAL_ENV" ; then
          PYTHON_VIRTUALENV=""
      else
          PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
          printf " $PYTHON_VIRTUALENV"
      fi
    }


    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly. 
        if [ $? -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
            local BG_EXIT_SEP="$BG_GREEN"
        else
            local BG_EXIT="$BG_RED"
            local BG_EXIT_SEP="$BG_RED"
        fi

        __set_sep_color

        PS1="$BG_DARK$FG_DARK \w $RESET"
        PS1+="$(__git_branch)$RESET"
        PS1+="$BG_EXIT_SEP$FG_EXIT_SEP$SEPARATOR_RIGHT$RESET"
        PS1+="$BG_EXIT$FG_BASE3 $PS_SYMBOL $RESET "
    }

    PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
