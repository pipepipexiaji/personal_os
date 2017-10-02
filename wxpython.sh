# base workdir
mkdir ~/wxpython_elcapitan
cd ~/wxpython_elcapitan
 
# download the wxPython dmg
curl -L "http://downloads.sourceforge.net/project/wxpython/wxPython/3.0.2.0/wxPython3.0-osx-3.0.2.0-cocoa-py2.7.dmg?r=http%3A%2F%2Fwww.wxpython.org%2Fdownload.php&ts=1453708927&use_mirror=netix" -o wxPython3.0-osx-3.0.2.0-cocoa-py2.7.dmg
 
# mount the dmg
hdiutil attach wxPython3.0-osx-3.0.2.0-cocoa-py2.7.dmg
 
# copy the dmg package to the local disk
mkdir ~/wxpython_elcapitan/repack_wxpython
cd ~/wxpython_elcapitan/repack_wxpython
cp -r /Volumes/wxPython3.0-osx-3.0.2.0-cocoa-py2.7/wxPython3.0-osx-cocoa-py2.7.pkg .
 
# unmount the dmg
dmgdisk="$(hdiutil info | grep '/Volumes/wxPython3.0-osx-3.0.2.0-cocoa-py2.7' | awk '{ print $1; }')"
hdiutil detach ${dmgdisk}
 
# prepare the new package contents
mkdir ~/wxpython_elcapitan/repack_wxpython/pkg_root
cd ~/wxpython_elcapitan/repack_wxpython/pkg_root
pax -f ../wxPython3.0-osx-cocoa-py2.7.pkg/Contents/Resources/wxPython3.0-osx-cocoa-py2.7.pax.gz -z -r
cd ~/wxpython_elcapitan/repack_wxpython
 
# prepare the new package scripts
mkdir ~/wxpython_elcapitan/repack_wxpython/scripts
cp wxPython3.0-osx-cocoa-py2.7.pkg/Contents/Resources/preflight scripts/preinstall
cp wxPython3.0-osx-cocoa-py2.7.pkg/Contents/Resources/postflight scripts/postinstall
 
# delete the old package
rm -rf ~/wxpython_elcapitan/repack_wxpython/wxPython3.0-osx-cocoa-py2.7.pkg
 
# build the new one :
pkgbuild --root ./pkg_root --scripts ./scripts --identifier com.wxwidgets.wxpython wxPython3.0-osx-cocoa-py2.7.pkg
 
# put the package on Desktop, and clean workdir
mv ~/wxpython_elcapitan/repack_wxpython/wxPython3.0-osx-cocoa-py2.7.pkg ~/Desktop/
cd ~
rm -rf ~/wxpython_elcapitan
 
# install it ! it will ask for your password (to become superuser/root)
sudo installer -pkg ~/Desktop/wxPython3.0-osx-cocoa-py2.7.pkg -target /
 
# EOF