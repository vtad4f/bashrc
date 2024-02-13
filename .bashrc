################################################################################
# 
# Useful aliases for git bash and unity
# 
################################################################################

# Is Mac?
if uname | grep Darwin > /dev/null ; then
   
    GITDIR="$HOME/Desktop/git"
else
    GITDIR=/c/git
WIN_GITDIR=C:\\git
fi

GITHUB=https://github.com/vtad4f

TRUE_=0
FALSE_=3

function _bg     { ("$@" &) ; return $? ; }

function ext     { find . -type f -name '*.*' | sed 's|.*\.||' | sort -u ; return $? ; } # list file extensions
function npp.new { notepad++ -multiInst -noPlugin -nosession "$@"        ; return $? ; } # open temp npp instance

function npp     { _bg notepad++ "$@" ; return $? ; } # open npp in bg
function editor  { _bg npp.new        ; return $? ; } # open temp npp instance in bg
function ex      { explorer .         ; return $? ; } # open explorer
function cmd     { cmd.exe "/C $@"    ; return $? ; } # run windows cmd

function help    { grep '^function [^_]' ~/.bashrc ; return $? ; } # list all fcns
function r       { source                ~/.bashrc ; return $? ; } # reload bashrc
function bashrc  { npp                   ~/.bashrc ; return $? ; } # open bashrc

function root    { cd $GITDIR                       ; return $? ; } # navigate to the git dir
function clone   { git clone $GITHUB/$1.git ${@:2}  ; return $? ; } # clone
function add     { git add                  "$@"    ; return $? ; } # add
function bd      { git branch -d             $1     ; return $? ; } # delete local branch
function bl      { git branch -vv                   ; return $? ; } # list local branches
function br      { git branch -r                    ; return $? ; } # list remote branches
function bn      { git branch -m             $1     ; return $? ; } # change branch name
function bu      { git branch -u      origin/$1     ; return $? ; } # change branch upstream
function bun     { bu "$1" ; bn "$1"                ; return $? ; } # change branch upstream and name
function clean   { git clean -dfqx          "$@"    ; return $? ; } # clean untracked files
function ch      { git checkout             "$@"    ; return $? ; } # checkout
function chm     { git checkout -B main origin/main ; return $? ; } # checkout main branch
function cmm     { git commit -m            "$1"    ; return $? ; } # commit with msg
function f       { git fetch -p             "$@"    ; return $? ; } # fetch (prune deleted branches)
function k       { f ; _bg gitk --all               ; return $? ; } # gitk
function rb      { git rebase               "$@"    ; return $? ; } # rebase
function rbi     { git rebase -i            "$@"    ; return $? ; } # rebase interactive
function rs      { git reset                "$@"    ; return $? ; } # reset
function soft    { git reset --soft HEAD~$1         ; return $? ; } # reset
function s       { git status               "$@"    ; return $? ; } # status
function pull    { git pull && git lfs pull         ; return $? ; } # fetch and rebase (+git lfs files)
function wipe    { rs . && ch . && clean .          ; return $? ; } # unstage, restore modified, and clean untracked files

function amm
{
   local msg_
   msg_="$1"
   [ -z "$msg_" ] && msg_=--no-edit
   git commit --amend "$msg_"

}

function assets  { cd $GITDIR/_unity/assets  ; return $?; } 
function build   { cd $GITDIR/_unity/build   ; return $?; } 
function project { cd $GITDIR/_unity/project ; return $?; } 
function scripts { cd $GITDIR/_unity/scripts ; return $?; } 

function unity.init   # copy the files from the unity project repo, then create symbolic links to others
{
   [[ "$(pwd)" != $GITDIR/* ]] && echo 'A unity project should be in the git folder!' && return $FALSE_
   [[ -d '.git' ]] && echo 'Remove the .git directory before overwriting the state of this repo!' && return $FALSE_
   cp -r $GITDIR/_unity/project/. . # copy everything from the template
   unity.mklink
}

function unity.mklink
{
   cmd "mklink /J build $WIN_GITDIR\\_unity\\build\\xcode"
   cd Assets
   cmd "mklink /J Scripts    $WIN_GITDIR\\_unity\\scripts\\src"
   cmd "mklink /J Sprites    $WIN_GITDIR\\_unity\\assets\\Sprites"
   cmd "mklink /J Tilesetter $WIN_GITDIR\\_unity\\assets\\Tilesetter"
   cd - > /dev/null
}

function unity.reset  # erase some of the files copied from the unity project repo
{
   [[ ! -d '.git' ]] && echo "Nothing to erase... This isn't a repo!" && return $FALSE_
   rm -rf .git
   rm Assets/Scripts
   rm Assets/Sprites
   rm Assets/Tilesetter
   rm build
   rm .gitignore
   rm README.md
}

function temp         # dump output to a temp file and open it
{
   local ret_
   local file_
   file_=temp.txt
   
   "$@" > $file_
   ret_=$?
   
   npp.new $file_
   rm $file_
   return $ret_
}

function xcode   { open -a Xcode ; return $? ; }
function xcode.common # add the Xcode content that shouldn't change
{
   add xcode/Classes                     \
       xcode/Data/Managed/mono           \
       xcode/Data/Managed/Resources      \
       xcode/Il2CppOutputProject/IL2CPP  \
       xcode/Libraries                   \
       xcode/MainApp                     \
       xcode/UnityFramework              \
       xcode/Unity-iPhone                \
       xcode/'Unity-iPhone Tests'        \
       xcode/Unity-iPhone.xcodeproj/xcshareddata \
       xcode/LaunchScreen-i*
}
function xcode.unique # add the Xcode content that's different between projects
{
   add xcode/Data                        \
       xcode/Il2CppOutputProject/Source  \
       xcode/Unity-iPhone.xcodeproj/project.pbxproj \
       xcode/Info.plist
}

if [[ "$(pwd)" == "$HOME" ]]; then
   root
fi

