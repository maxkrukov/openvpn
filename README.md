#### Instalation script

```
## OPENVPN
AUTO_INSTALL=y DH_TYPE=2 PORT_CHOICE=2 PORT=31194 ./openvpn-install.sh
if ( ps aux | grep openvpn | grep -v grep > /dev/null 2>&1 ); then
    echo "Success: OpenVPN is running"
else
    echo "Failure: OpenVPN is not running"
    exit 1
fi
```
