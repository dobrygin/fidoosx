#!/bin/bash

NOWDIR=`pwd`
BASEDIR=$HOME/fidoosx
NAME="Moris Haos"
AKA="2:5083/444.999"
SYS="FreeBSD_ORG_KZ"
LOC="Astana, Kazakhstan"
PASWD="password"
BNAME="Peter Khanin"
BAKA="2:5083/444"
BIP="freebsd.org.kz"

echo -ne "Enter your path to FidoOSX basedir [ $BASEDIR ]: "
read TMP
if [ "$TMP" != "" ]; then BASEDIR=$TMP; fi

echo -ne "Enter your real name [ $NAME ]: "
read TMP
if [ "$TMP" != "" ]; then NAME=$TMP; fi

echo -ne "Enter your FTN-address [ $AKA ]: "
read TMP
if [ "$TMP" != "" ]; then AKA=$TMP; fi

echo -ne "Enter your location City and Country [ $LOC ]: "
read TMP
if [ "$TMP" != "" ]; then LOC=$TMP; fi

echo -ne "Enter your computer's name [ $SYS ]: "
read TMP
if [ "$TMP" != "" ]; then SYS=$TMP; fi

echo -ne "Enter real name your uplink [ $BNAME ]: "
read TMP
if [ "$TMP" != "" ]; then BNAME=$TMP; fi

echo -ne "Enter your uplink FTN-address [ $BAKA ]: "
read TMP
if [ "$TMP" != "" ]; then BAKA=$TMP; fi

echo -ne "Enter your uplink ip or dns name [ $BIP ]: "
read TMP
if [ "$TMP" != "" ]; then BIP=$TMP; fi

echo -ne "Enter your uplink password [ $PASWD ]: "
read TMP
if [ "$TMP" != "" ]; then PASWD=$TMP; fi

if [ ! -d $BASEDIR ]; then mkdir $BASEDIR; fi
if [ ! -d $BASEDIR ]; then echo "Can't create $BASEDIR"; exit; fi
cd $BASEDIR
tar xfvz "$NOWDIR/fidoosx.tgz"

cat > $BASEDIR/etc/binkd.config <<EOF
domain fidonet $BASEDIR/fido/outbound 2
address  $AKA@fidonet
sysname "$SYS"
location "$LOC"
sysop "$NAME"
nodeinfo 1M,TCP,BINKP
call-delay 20
rescan-delay 5
try 1
hold 5
send-if-pwd
log $BASEDIR/fido/binkd.log
loglevel 4
conlog 4
percents
printq
inbound $BASEDIR/fido/localinb
inbound-nonsecure $BASEDIR/fido/protinb
temp-inbound $BASEDIR/fido/tempinb
minfree 2048
minfree-nonsecure 2048
kill-dup-partial-files
kill-old-partial-files 86400
kill-old-bsy 43200
prescan
node $BAKA $BIP $PASWD
EOF

cat > $BASEDIR/etc/husky/husky.cfg <<EOF
Name $SYS
Sysop $NAME
Location $LOC
Address $AKA@fidonet
if "[module]"=="hpt"
Origin High Portable Tosser
else
endif
Inbound $BASEDIR/fido/inbound
ProtInbound $BASEDIR/fido/protinb
LocalInbound $BASEDIR/fido/localinb
Outbound $BASEDIR/fido/outbound
tempOutbound $BASEDIR/fido/tempoutb
tempInbound $BASEDIR/fido/tempinb
MsgBaseDir $BASEDIR/fido/msgbasedir
public $BASEDIR/fido/public
echotosslog $BASEDIR/fido/echotoss.log
importlog $BASEDIR/fido/import.log
logFileDir $BASEDIR/fido/
DupeHistoryDir $BASEDIR/fido/msgbasedir
NodelistDir $BASEDIR/fido/nodelist
magic $BASEDIR/fido/magic
lockfile $BASEDIR/fido/flags/hpt-lock
AdvStatisticsFile $BASEDIR/fido/hpt-adv.sta
NetmailFlag $BASEDIR/fido/flags/hpt-mail
SEQDIR $BASEDIR/fido/seq
AdvisoryLock 10
LogLevels 134567890ABCDEFGJKLMNT
LogEchoToScreen
nodelist $BASEDIR/fido/nodelist
LinkWithImportLog Kill
#########################################################################
# Так как hpt собран без поддержки архиваторов, то нужно установить
# консольные zip, unzip, unrar
# К примеру, использовать Macports - https://www.macports.org/
# Что это такое можно узнать тут - https://ru.wikipedia.org/wiki/MacPorts
#########################################################################
Unpack "unzip -joLqq \$a -d \$p" 0 504b0304
Pack zip zip -9jgq \$a \$f
Unpack "unrar e -y -c- -o+ -inul \$a \$p \$f" 0 52617221
LinkDefaults begin
ArcmailSize 400
PktSize 300
allowEmptyPktPwd secure
allowPktAddrDiffer off
#########################################################################
# Так как hpt собран без поддержки архиваторов, то нужно установить
# консольные zip, unzip, unrar
# К примеру, использовать Macports - https://www.macports.org/
# Что это такое можно узнать тут - https://ru.wikipedia.org/wiki/MacPorts
#########################################################################
Packer zip
Level 3000
AccessGrp A
ForwardRequests on
AutoCreate on
areafixName AreaFix
EchomailFlavour Direct
AutoAreaCreateSubdirs off
filefixName FileFix
FileEchoFlavour Normal
AutoFileCreateSubdirs off
LinkDefaults end
Link $BNAME
Aka $BAKA
OurAKA $AKA
Password $PASWD
AreafixAutoCreateDefaults -b Jam -dupeCheck move -dupeHistory 14
AreafixAutoCreateFile $BASEDIR/etc/husky/areas.cfg
FilefixAutoCreateFile $BASEDIR/etc/husky/fileareas.cfg
LinkDefaults begin
ArcmailSize 400
PktSize 300
allowEmptyPktPwd secure
allowPktAddrDiffer off
#########################################################################
# Так как hpt собран без поддержки архиваторов, то нужно установить
# консольные zip, unzip, unrar
# К примеру, использовать Macports - https://www.macports.org/
# Что это такое можно узнать тут - https://ru.wikipedia.org/wiki/MacPorts
#########################################################################
Packer zip
Level 2500
AccessGrp A,L
ForwardRequests off
AutoCreate off
areafixName AreaFix
EchomailFlavour Normal
AutoAreaCreateSubdirs off
filefixName FileFix
FileEchoFlavour Hold
AutoFileCreateSubdirs off
LinkDefaults end
include $BASEDIR/etc/husky/areas.cfg
DupeBaseType HashDupesWMsgId
SeparateBundles
BundleNameStyle addrsCRC32
DefArcmailSize 300
ReportTo netmail
CarbonOut off
ExcludePassthroughCarbon
CarbonExcludeFwdFrom off
CarbonKeepSb
route crash $BAKA *
fileAreaDefaults $BAKA
OriginInAnnounce
ConvertLongNames Upper
ConvertShortNames Upper
FileDescName file_id.diz
FileDescPos 13
AnnounceSpool $BASEDIR/fido/announce
SaveTic * $BASEDIR/fido/tics
FileAreaBaseDir $BASEDIR/fileecho
PassFileAreaDir $BASEDIR/fileecho
Include $BASEDIR/etc/husky/fileareas.cfg
if "[module]"=="htick"
Origin High Portable Ticker
endif
EOF

cat > $BASEDIR/etc/husky/areas.cfg <<EOF
##################################################################
# Has to be in the coding KOI8-R codepage
##################################################################
EchoAreaDefaults -b Jam -dupecheck move -dupehistory 11
EchoAreaDefaults OFF
NetmailArea NetmailArea $BASEDIR/fido/netmailarea -b msg -d "NetMail"
BadArea BadArea $BASEDIR/fido/badarea -b msg -d "BadMail"
DupeArea DupeArea $BASEDIR/fido/dupearea/dupearea -b Jam -d "DupeMail"
dupebasetype HashDupes
areasmaxdupeage	20
LocalArea CarbonArea $BASEDIR/fido/carbonarea/carbonarea -b Jam -d "CarbonArea"
CarbonTo $NAME
CarbonCopy CarbonArea
EOF

cat > $BASEDIR/etc/husky/fileareas.cfg <<EOF
#
EOF

cat > $BASEDIR/etc/golded/golded.cfg <<EOF
##################################################################
# Has to be in the coding KOI8-R codepage
##################################################################
username $NAME
Address $AKA
XLATPATH $BASEDIR/etc/golded/cfgs/charset/
XLATLOCALSET KOI8
XLATIMPORT CP866
XLATEXPORT CP866
XLATCHARSET KOI8 CP866 koi_866.chs
XLATCHARSET CP866 KOI8 866_koi.chs
IGNORECHARSET
CTRLINFONET TEARLINE, ORIGIN
CTRLINFOECHO TEARLINE, ORIGIN
CTRLINFOLOCAL TEARLINE, ORIGIN
TEARLINE binkd/1.1a-94/Darwin | hpt/mac 1.9.0-cur | @longpid @version
ORIGIN "Per Aspera Ad Astra"
TAGLINESUPPORT Yes
TAGLINE You_Tagline
COLOR MENU UNREAD YELLOW ON BLACK
HighlightUnread Yes
SEMAPHORE EXPORTLIST $BASEDIR/fido/echotoss.log
SEMAPHORE IMPORTLIST $BASEDIR/fido/import.log
AreaFile Fidoconfig $BASEDIR/etc/husky/areas.cfg
LOADLANGUAGE $BASEDIR/etc/golded/goldlang.cfg
AREASCAN *
EditSoftCrXLat H
UseSoftCRxlat Yes
DispSoftCr Yes
VIEWHIDDEN NO
VIEWKLUDGE NO
TwitName Bad User
TwitName Urgy Spammer
TwitMode Skip
TwitTo Yes
UuDecodePath $BASEDIR/fido/uudecode
Invalidate Tearline "" ""
Invalidate Origin "" ""
EditCrlFTerm No
ViewQuote Yes
ImportBegin -Cut On @file-
ImportEnd -Cut Off @file-
OutPutFile $BASEDIR/fido/outfile/
AttribsNet Loc Pvt
DispMsgSize Kbytes
DispAttachSize Kbytes
NodelistWarn No
TemplatePath $BASEDIR/etc/golded
Template golded.tpl "Default Template"
include $BASEDIR/etc/golded/colorset/gedcol10.cfg
NodePath $BASEDIR/fido/nodelist
NODELIST NODELIST.999
NODELIST PNT5005.999
NODELIST PNT5010.999
NODELIST PNT5019.999
NODELIST PNT5020.999
NODELIST PNT5025.999
NODELIST PNT5027.999
NODELIST PNT5033.999
NODELIST PNT5052.999
NODELIST PNT5057.999
NODELIST PNT5061.999
NODELIST PNT5080.999
RobotName AreaFix
RobotName AllFix
RobotName T-fix
RobotName FAQServer
LogFile $BASEDIR/fido/golded.log
AddressMacro af,AreaFix,$BAKA,"password"
AddressMacro ff,FileFix,$BAKA,"password"
AddressBookAdd Always
^B READAddressBookAdd
@F10 READUserBase
AreaSep	!NET	"NM"	0	Net
AreaSep	!LOCAL	"Local"	0	Local
AreaSep	!ECHO	"Echos"	0	Echo
ConfirmFile golded.cfm
ConfirmResponse Ask
AREALISTGROUPID YES
AREALISTSORT TUE
PeekURLOptions FromTop
URLHANDLER -NoPause -NoKeepCtrl -Wipe /Applications/Firefox.app/Contents/MacOS/firefox @url > /dev/null 2>&1 &
DispHdrLocation Yes
MsgListHeader 1
KeybExt Yes
QuoteCtrl No
Include $BASEDIR/etc/golded/aliasru.cfg
EOF

cat > $BASEDIR/geosx <<EOF
#!/bin/sh
export LANG="ru_RU.KOI8-R"
export LC_ALL="ru_RU.KOI8-R"
export LC_TYPE="ru_RU.KOI8-R"
LANG="ru_RU.KOI8-R"
LC_ALL="ru_RU.KOI8-R"
LC_TYPE="ru_RU.KOI8-R"
FROOT=$BASEDIR
CFG=\$FROOT/etc/golded/golded.cfg
BIN=\$FROOT/bin/gedosx
\$BIN -c\$CFG
EOF
chmod 755 $BASEDIR/geosx

cat > $BASEDIR/0.spsrtttl <<EOF
#!/bin/sh
$BASEDIR/bin/hpt -c $BASEDIR/etc/husky/husky.cfg scan
$BASEDIR/bin/hpt -c $BASEDIR/etc/husky/husky.cfg pack
$BASEDIR/bin/binkd -p -P $BAKA $BASEDIR/etc/binkd.config
$BASEDIR/bin/hpt -c $BASEDIR/etc/husky/husky.cfg toss
$BASEDIR/bin/hpt -c $BASEDIR/etc/husky/husky.cfg link
$BASEDIR/bin/htick -c $BASEDIR/etc/husky/husky.cfg toss
$BASEDIR/bin/htick -c $BASEDIR/etc/husky/husky.cfg filelist $BASEDIR/fileecho/filelist.txt
EOF
chmod 755 $BASEDIR/0.spsrtttl

cat > $BASEDIR/scan-pack <<EOF
#!/bin/sh
$BASEDIR/bin/hpt -c $BASEDIR/etc/husky/husky.cfg scan
$BASEDIR/bin/hpt -c $BASEDIR/etc/husky/husky.cfg pack
EOF
chmod 755 $BASEDIR/scan-pack

cat > $BASEDIR/send-recv <<EOF
#!/bin/sh
$BASEDIR/bin/binkd -p -P $BAKA $BASEDIR/etc/binkd.config
EOF
chmod 755 $BASEDIR/send-recv

cat > $BASEDIR/toss-link <<EOF
#!/bin/sh
$BASEDIR/bin/hpt -c $BASEDIR/etc/husky/husky.cfg toss
$BASEDIR/bin/hpt -c $BASEDIR/etc/husky/husky.cfg link
EOF
chmod 755 $BASEDIR/toss-link

cat > $BASEDIR/tic-toss-flist <<EOF
#!/bin/sh
$BASEDIR/bin/htick -c $BASEDIR/etc/husky/husky.cfg toss
$BASEDIR/bin/htick -c $BASEDIR/etc/husky/husky.cfg filelist $BASEDIR/fileecho/filelist.txt
EOF
chmod 755 $BASEDIR/tic-toss-flist

cat > $BASEDIR/nlgen <<EOF
#!/bin/sh
$BASEDIR/bin/gnosx -c $BASEDIR/etc/golded/golded.cfg
EOF
chmod 755 $BASEDIR/nlgen

$BASEDIR/bin/gnosx -c $BASEDIR/etc/golded/golded.cfg

echo "!!!"
echo "!!! Installation FidoOSX is executed successfully."
echo "!!! Please read README file."
echo "!!!"
echo "!!! Don't forget install zip, unzip, unrar from MacPorts."
echo "!!!"
