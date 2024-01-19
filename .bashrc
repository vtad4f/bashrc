################################################################################
# 
# Useful aliases for git bash and unity
# 
################################################################################

# Is Mac?
if uname | grep Darwin > /dev/null ; then
   
   # Start by setting up all the user-specific content
   GITDIR="$HOME/Desktop/git"
   
   export DOTNET_ROOT="$HOME/Desktop/dotnet"
   export PATH="$DOTNET_ROOT:$PATH"
else
   GITDIR=C:/git
fi
GITHUB=https://github.com/vtad4f


TRUE_=0
FALSE_=3

function _bg    { ("$@" &) ; return $? ; }

function ext     { find . -type f -name '*.*' | sed 's|.*\.||' | sort -u ; return $? ; } # list file extensions
function npp.new { notepad++ -multiInst -noPlugin -nosession "$@"        ; return $? ; } # open temp npp instance

function npp     { _bg notepad++ "$@" ; return $? ; } # open npp in bg
function editor  { _bg npp.new        ; return $? ; } # open temp npp instance in bg
function ex      { explorer .         ; return $? ; } # open explorer
function root    { builtin cd $GITDIR ; return $? ; } # navigate to the git dir

function help    { grep '^function [^_]' ~/.bashrc ; return $? ; } # list all fcns
function r       { builtin source        ~/.bashrc ; return $? ; } # reload bashrc
function bashrc  { npp                   ~/.bashrc ; return $? ; } # open bashrc

function clone   { git clone $GITHUB/$1.git ${@:2} ; return $? ; }
function add     { git add                    "$@" ; return $? ; }
function b       { bn "$1" ; bu "$1"               ; return $? ; }
function bn      { git branch -m               $1  ; return $? ; }
function bu      { git branch -u        origin/$1  ; return $? ; }
function cmm     { git commit -m              "$1" ; return $? ; }
function k       { _bg gitk --all                  ; return $? ; }
function rs      { git reset                  "$@" ; return $? ; }
function s       { git status                 "$@" ; return $? ; }

function xcode   { open -a Xcode                   ; return $? ; }
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


if [[ "$(pwd)" == "$HOME" ]]; then
   root
fi

