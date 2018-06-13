# run `echo "source ~/Dropbox/dotfiles/bashrc" >> ~/.bashrc`

# show mysql grants
# you can use your full unix tool kit on this like so:
# mygrants --host=prod-db1 --user=admin --password=secret | grep some_username | mysql --host=staging-db1 --user=admin --password=secret
mygrants() {
  mysql -B -N $@ -e "SELECT DISTINCT CONCAT(
    'SHOW GRANTS FOR ''', user, '''@''', host, ''';'
    ) AS query FROM mysql.user" | \
  mysql $@ | \
  sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}'
}

# simple console translator powered by Yandex.Translate
# http://api.yandex.com/translate/doc/dg/reference/translate.xml
source ~/Dropbox/dotfiles/.yandex_api_key
en() { wget -qO- "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$YANDEX_TR_API_KEY&lang=en-ru&text=$1"; echo ""; }

# mc remember last dir
# work only in same terminal =(
#source /usr/share/mc/bin/mc.sh

# force tmux to assume the terminal supports 256 colours.
alias tmux="tmux -2"
alias tat="tmux new-session -As"
# run mc in xterm-mode
#alias mc="mc -x"

alias asterisk_no_comments="grep -vP \"^\s*;|^$\""

# colorify STDERR
# (c)http://serverfault.com/a/502019
color() (set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1

# now bc '(3+5)/6' works as expected
# (c)http://chakravir.net/doku.php/notes/bc_cheat_sheet
# тупит
#bc() { echo $@ | bc -l -q ~/Dropbox/extensions.bc; }

# auto-complete local databases
# dont forget to add user and password to [client] section of ~/.my.cnf
# (c)http://habrahabr.ru/post/142717/
function __mysql_list_all_opts {
	local i IFS=$'\n'
	mysql --help|egrep '^ -'|awk '{print $1 "\n" $2}'|egrep '^-'|sed s/,$//|sort
}

__mysql_all_opts=
function __mysql_compute_all_opts {
	: ${__mysql_all_opts:=$(__mysql_list_all_opts)}
}

function _mysql_complete {
	local cur prev opts

	COMPREPLY=()
	cur=`_get_cword`
	prev=${COMP_WORDS[COMP_CWORD-1]}

	case $prev in
		*)
			if [[ "$cur" == -* ]]; then
				__mysql_compute_all_opts
				opts=${__mysql_all_opts}
			else
				opts=$(mysql -uroot -s -e 'show databases')
			fi
			;;
	esac

	COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
	COMPREPLY=( $(compgen -W "$opts" -- $cur) )
}

complete -F _mysql_complete mysql

haste() { a=$(cat); curl -X POST -s -d "$a" http://hastebin.com/documents | awk -F '"' '{print "http://hastebin.com/"$4}' | xsel -b; }

# python virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
source /usr/local/bin/virtualenvwrapper.sh

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi


# verify command when using !!
shopt -s histverify

# python autocomplete
export PYTHONSTARTUP="${HOME}/Dropbox/.pyrc"
export PYTHONIOENCODING="UTF-8"

mysql_grants() {
        mysql --silent --skip-column-names --execute "select concat('\'',User,'\'@\'',Host,'\'') as User from mysql.user" | sort | \
        while read u
                do echo "-- $u"; mysql --silent --skip-column-names --execute "show grants for $u" | sed 's/$/;/'
        done
}

# colored man pages 
# http://askubuntu.com/a/439411/260920
man() {
    case "$(type -t -- "$1")" in
    builtin|keyword)
        help -m "$1" | `which less`
        ;;
    *)
        env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
        ;;
    esac
}

alias netrestart="sudo nohup sh -c 'ifdown -a && ifup -a'"

function show_crontabs {
        for user in $(cut -f1 -d: /etc/passwd)
        do
                echo $user;
                crontab -u $user -l;
        done
}

# List installed deb packages by size
# or you can use wajig large (Requires the "wajig" package to be installed.)
pkgbysize() {
	dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n
}

# disable color for ipcalc
alias ipcalc="ipcalc --nocolor"
# file tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
#turn screen off
alias screenoff="xset dpms force off"
# list folders by size in current directory
alias usage="du -h --max-depth=1 | sort -rh"
# e.g., up -> go up 1 directory
# up 4 -> go up 4 directories
up() {
    dir=""
    if [[ $1 =~ ^[0-9]+$ ]]; then
        x=0
        while [ $x -lt ${1:-1} ]; do
            dir=${dir}../
            x=$(($x+1))
        done
    else
         dir=..
    fi
    cd "$dir";
}

taocl() {
        curl -s https://raw.githubusercontent.com/jlevy/the-art-of-command-line/master/README-ru.md |
        pandoc -f markdown -t html -s |
        xmllint --format --recover --dropdtd --html --xpath "(html/body/ul/li[count(p)>0])[$RANDOM mod last()+1]" - 2>/dev/null |
        html2text -utf8 |
        fmt -80
}

rfc() {
        if [ ! -d ~/rfc/ ]; then
                mkdir -p ~/rfc/;
        fi
        if [ ! -e ~/rfc/rfc"$@".txt ]; then
                wget -O ~/rfc/rfc"$@".txt https://www.ietf.org/rfc/rfc"$@".txt
        fi
        less ~/rfc/rfc"$@".txt
}

# golang preferences
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export PATH="$PATH":~/bin
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# pygmentize less
export LESS='-r'
#export LESSOPEN='| ~/.lessfilter %s'
export LESSOPEN='| pygmentize -f terminal256 -g -P style=native %s'

# cowsay
COWPATH="$COWPATH:$HOME/.vim/.cowsay"

showssl() {
        echo | openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null | openssl x509 -inform pem -noout -text
}

wttr() {
    # change Yyzhno-Sakhalinsk to your default location
    curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1:-Южно-Сахалинск}"
}

mp3towav() {
    a="$@"
    mpg123 -w "${a/.mp3/.wav/}" "${a}"
}

toalaw() {
    a="$@"
    sox -V "${a}" -r 8000 -c 1 -t al "${a/.wav/.alaw/}"
}

wav2gsm() {
    for a in *.wav; do
        sox -V "$a" -r 8000 -c 1 -t gsm ${a/.wav/.gsm/}
    done
}

wav2alaw() {
    for a in *.wav; do
        sox -V "$a" -r 8000 -c 1 -t al ${a/.wav/.alaw/}
    done
}

foreach() { 
  arr="$(declare -p $1)" ; eval "declare -A f="${arr#*=}; 
  for i in ${!f[@]}; do $2 "$i" "${f[$i]}"; done
  #
  # example:
  #
  #$ bar(){ echo "$1 -> $2"; }
  #$ declare -A foo["flap"]="three four" foo["flop"]="one two"
  #$ foreach foo bar
  #flap -> three four
  #flop -> one two
}

vim() {
  local STTYOPTS="$(stty --save)"
  stty stop '' -ixoff
  command vim "$@"
  stty "$STTYOPTS"
}

mkrole() {
        mkdir -p "./$1/"{tasks,handlers,files,templates,vars,defaults,meta}
        touch "./$1/"{tasks,handlers,vars,defaults,meta}/main.yml
}
