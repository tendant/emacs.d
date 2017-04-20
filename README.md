emacs.d
=======

An new beginning of my emacs.d

HOWTO
-------

## Clone repository into ~/emacs.d
<code>
  git clone git@github.com:your-nick/emacs.d.git
</code>
## Create a new file in ~/.emacs.d/init.el
<code>
   (load "~/emacs.d/my-init.el")
</code>


Install Latest Stable emacs in Ubuntu
----
## Install build dependencies

<code>
sudo apt install build-essential checkinstall
sudo apt-get build-dep emacs24 # enable source in ubuntu software configruation
</code>

## Build and install Emacs 25

<code>
sudo apt-get update
sudo wget http://ftp.gnu.org/gnu/emacs/emacs-25.1.tar.gz
sudo tar xzvf emacs-25.1.tar.gz
cd emacs-25.1
./configure
make
sudo checkinstall
</code>

<code>
sudo add-apt-repository -y ppa:ubuntu-elisp
sudo apt-get update
sudo apt-get install emacs-snapshot
</code>
