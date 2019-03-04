set -g theme_display_user yes
set -g theme_display_hostname yes
set -g theme_date_format "+%Y-%m-%d %H:%M:%S"
# ... and don't forget to install Oh My Fish and bobthefish

# Wrapper aliases for OS-specific stuff
switch (uname)
    case Darwin
        alias cb='pbcopy'
        alias numcores='sysctl -n hw.physicalcpu'
        alias numthreads='sysctl -n hw.logicalcpu'
    
    case Linux
        function cb
            # xclip is available and can execute (X is running)
            if type -q xclip and xclip -o 2>/dev/null
                xclip $argv
            else
                tee $argv
            end
        end
        function numcores
            set sockcount (lscpu | awk '/^Socket\(s\)/{print $2}')
            set corecount (lscpu | awk '/Core\(s\) per socket/{print $4}')
            math "$sockcount * $corecount"
        end
        # alias numthreads='grep -c ^processor /proc/cpuinfo'
        alias numthreads='nproc'
    
    case '*'
        alias cb='tee'
        alias numcores='echo 1'
        alias numthreads='echo 1'
end

alias lah='ls -lah'
alias mmake='make -j (numthreads)'
alias extglob='shopt -s extglob'
alias hgmt='hg merge -t internal:merge'

function linecount
    wc -l (find $argv -type f)
end

function pless
    # unbuffer $argv 2>&1 | less -r
    # unbuffer $argv | less -r
    # less -r ( $argv 2>&1 | psub -f )
    unbuffer fish -c (string escape -- $argv) | less -r
end

# Fun stuff
alias shrug='echo -n "¯\_(ツ)_/¯" | cb'
alias shrug3='echo -n "¯\_(=3=)_/¯" | cb'
alias really='echo -n ಠ_ಠ | cb'
alias nyet='echo -n нет | cb'
alias weary='echo -n 😩 | cb'
alias thinking='echo -n 🤔 | cb'
