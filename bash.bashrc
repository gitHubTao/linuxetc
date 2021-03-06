# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ]; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- $1
                   return $?
                elif [ -x /usr/share/command-not-found ]; then
		   /usr/bin/python /usr/share/command-not-found -- $1
                   return $?
		else
		   return 127
		fi
	}
fi
# function to print colorful words in shell
function ecolor()
{

case $1 in
	black)
	    color=30
	    ;;
	red)
	    color=31
	    ;; 
	green)
	    color=32
	    ;;
	yellow)
	    color=33
	    ;;
	blue)
	    color=34
	    ;;
	white)
	    color=37
	    ;;
	*)
	    echo $2
	    return 1
	    ;;
esac

echo -e "\033[49;${color};1m$2\033[0m" 

return 0

}
# load bashrc.local  ,put some uncompetical config  file here
if [ -f /etc/bashrc.local ]; then
	. /etc/bashrc.local
fi

# add by zs 2012  07  12
   alias cda='cd ..'
   alias cdb='cd ../..'
   alias cdc='cd ../../..'
   alias cdd='cd ../../../..'
   alias cde='cd ../../../../..'
# kill process by grep name
function gkill(){
echo "Input a word to grep and kill"
read process
echo $process
 ps -ef|grep $process
 ps -ef|grep chrome|awk '{print$2""}'|xargs kill -9
 
}
#script to switch apache to nginx
function a2n(){
sudo pkill -9 apache2
sudo /usr/bin/spawn-fcgi -a 127.0.0.1 -p 9000 -C 8 -u www-data -g www-data -f "/usr/bin/php5-cgi -d /var/www"
sudo /usr/local/nginx/sbin/nginx 
sudo netstat -ntpl|grep 0.0.0.0:80
}
#script to switch nginx to apache 
function n2a(){
sudo pkill -9 nginx
sudo pkill -9 php5-cgi
sudo /etc/init.d/apache2 start
sudo netstat -ntpl|grep 0.0.0.0:80
}
