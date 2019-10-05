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
    
    case FreeBSD
        alias cb='tee'
        function numthreads
            sysctl -n hw.ncpu
        end
        function numcores
            set smp_active (string replace -r '^.+: ' '' -- (sysctl kern.smp.active))
            math (numthreads) / \($smp_active + 1\)
        end
    
    case '*'
        alias cb='tee'
        alias numcores='echo 1'
        alias numthreads='echo 1'
end

alias lah='ls -lah'
alias mmake='make -j (numthreads)'
alias extglob='shopt -s extglob'
alias hgmt='hg merge -t internal:merge'

begin
    # MSVC:  /WX /Wall
    
    set -l CLANG_C_WARNINGS_EXTRA '-Wall -Wextra -Wshadow -Wcast-align -Wunused -Wpedantic -Wconversion -Wsign-conversion -Wnull-dereference -Wdouble-promotion -Wformat=2'
    set -l GCC_C_WARNINGS_EXTRA '-Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wuseless-cast'
    set -l CLANG_CPP_WARNINGS_EXTRA '-Wnon-virtual-dtor -Wold-style-cast -Woverloaded-virtual'
    set -l GCC_CPP_WARNINGS_EXTRA ''
    
    set C_EXTRA_WARNINGS_CLANG "$CLANG_C_WARNINGS_EXTRA"
    set C_EXTRA_WARNINGS_GCC "$CLANG_C_WARNINGS_EXTRA $GCC_C_WARNINGS_EXTRA"
    set CPP_EXTRA_WARNINGS_CLANG "$CLANG_C_WARNINGS_EXTRA $CLANG_CPP_WARNINGS_EXTRA"
    set CPP_EXTRA_WARNINGS_GCC "$CLANG_C_WARNINGS_EXTRA $GCC_C_WARNINGS_EXTRA $CLANG_CPP_WARNINGS_EXTRA $GCC_CPP_WARNINGS_EXTRA"

    alias clangw="clang $C_EXTRA_WARNINGS_CLANG"
    alias gccw="gcc $C_EXTRA_WARNINGS_CLANG"
    alias clang++w="clang++ $CPP_EXTRA_WARNINGS_CLANG"
    alias g++w="g++ $CPP_EXTRA_WARNINGS_CLANG"

    alias clangwe="clang $C_EXTRA_WARNINGS_CLANG -Werror"
    alias gccwe="gcc $C_EXTRA_WARNINGS_CLANG -Werror"
    alias clang++we="clang++ $CPP_EXTRA_WARNINGS_CLANG -Werror"
    alias g++we="g++ $CPP_EXTRA_WARNINGS_CLANG -Werror"
end

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
