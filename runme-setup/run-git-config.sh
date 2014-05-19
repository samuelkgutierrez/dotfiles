# sets up my .gitconfig
# user
git config --global user.name "Samuel K. Gutierrez"
git config --global user.email "samuel@lanl.gov"
git config --global user.signingkey "Samuel K. Gutierrez (LANL)"
# color
git config --global color.branch auto
git config --global color.diff  auto
git config --global color.status auto
# alias
git config --global alias.co checkout
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.snapshot "!git stash save 'snapshot: \$(date)' && git stash apply "stash@{0}""
# core
git config --global core.editor vim
# push
git config --global push.default simple
# credential
git config --global credential.helper 'cache --timeout=43200'
