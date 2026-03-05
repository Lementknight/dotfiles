
eval "$(/opt/homebrew/bin/brew shellenv)"

##
# Your previous /Users/caaguirr/.zprofile file was backed up as /Users/caaguirr/.zprofile.macports-saved_2023-09-11_at_17:14:31
##

# MacPorts Installer addition on 2023-09-11_at_17:14:31: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2023-09-11_at_17:14:31: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH="/opt/local/share/man:$MANPATH"
# Finished adapting your MANPATH environment variable for use with MacPorts.


# Created by `pipx` on 2023-11-08 20:09:55
export PATH="$PATH:/Users/caaguirr/.local/bin"

# Added by `rbenv init` on Thu Aug 29 10:28:52 EDT 2024
eval "$(rbenv init - --no-rehash zsh)"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

eval "$(/usr/local/bin/brew shellenv zsh)"
