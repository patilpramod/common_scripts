net stop wuauserv
cd% systemroot% \ SoftwareDistribution
ren Download Download.old
net start wuauserv
net stop bits
net start bits
net stop cryptsvc
cd% systemroot% \ system32
ren catroot2 catroot2old
net start cryptsvc

Wuauclt.exe / resetauthorization / detectnow