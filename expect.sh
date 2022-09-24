#!/bin/bash


####
list_users() {
ls -1 /etc/openvpn/easy-rsa/pki/private/ \
 | grep -Ev '(ca|server_[a-zA-Z0-9]+)\.key' \
 | sed 's/.key$//g'
}


####
create() {
if [[ -z $1 ]]; then
 echo "USAGE: expect.sh create <user> <passwork>"
 exit 1
elif [[ -z $2 ]]; then
 echo "USAGE: expect.sh create <user> <passwork>"
 exit 1
fi

user=$1
pass=$2

if ( list_users | grep "^${user}$" ); then
  echo "User <${user}> has been already created. Skipping..."
  exit 0
fi

expect -f <(cat << EOF
  spawn openvpn-install.sh

  expect "Select an option:"
  send "1\r"

  expect "Client name:"
  send "${user}\r"

  expect "Select an option:"
  send "2\r"

  expect "Password:"
  send "${pass}\r"
  expect "Password:"
  send "${pass}\r"

  expect "anything that will surely not be there on page"
  send_user "$expect_out(buffer)"
EOF
)
}



####
revoke() {

if [[ -z $1 ]]; then
 echo "USAGE: expect.sh revoke <user>"
 exit 1
fi

user=$1

if ( ! list_users | grep "^${user}$" ); then
  echo "User <${user}> has been already revoked. Skipping..."
  exit 0
fi

expect -f <(cat << EOF
  spawn openvpn-install.sh

  expect "Select an option:"
  send "2\r"

  expect "Client name:"
  send "${user}\r"

  expect "anything that will surely not be there on page"
  send_user "$expect_out(buffer)"
EOF
)
}
####

  case $1 in
	create)
		create $2 $3
		;;
	revoke)
		revoke $2
		;;
        list)
                list_users
                ;;
	*)
		echo "USAGE: expect.sh create/revoke/list <user> <password>"
		;;
  esac
