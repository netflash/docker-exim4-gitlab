#!/bin/bash

exim-list(){
  local res="$1"
  shift
  for item in "$@"; do
    res="$res : $item"
  done
  printf %s "$res"
}

setup(){
  [ x$LOCAL_DOMAINS = x ] && LOCAL_DOMAINS=localhost:localhost.localdomain
  [ x$RELAY_DOMAINS = x ] && RELAY_DOMAINS=$LOCAL_DOMAINS
  [ x$MAILNAME = x ]      && MAILNAME=localhost.localdomain
  [ x$RELAY_NETWORKS = x ] && RELAY_NETWORKS=127.0.0.0/24:127.1.0.0/24
  [ x$SMARTHOST = x ]      && SMARTHOST=smarthost
  [ x$REDIRECT_TO = x ]      && REDIRECT_TO=example@example.com
  sed -e "s|%LOCAL_DOMAINS%|$(exim-list $LOCAL_DOMAINS)|g" \
      -e "s|%RELAY_DOMAINS%|$(exim-list $RELAY_DOMAINS)|g" \
      -e "s|%MAILNAME%|$(exim-list $MAILNAME)|g" \
      -e "s|%RELAY_NETWORKS%|$(exim-list $RELAY_NETWORKS)|g" \
      -e "s|%SMARTHOST%|$(exim-list $SMARTHOST)|g" \
      -e "s|%REDIRECT_TO%|$(exim-list $REDIRECT_TO)|g" \
      /etc/exim4/exim4.conf.tpl \
      >/etc/exim4/exim4.conf
  # get passwd client from /mnt folder
  [ -e /mnt/passwd.client ] && cp -f /mnt/passwd.client /etc/exim4
}

case "${1}" in
    bash)
      if ! tty >/dev/null 2>&1; then
        echo "Must be run with -t (--tty) option"
        exit 1
      fi
      setup
      exec bash
      ;;
    init)
      setup
      exec /usr/bin/svscanboot 
      ;;
  *)
    echo "export LOCAL_DOMAINS=..."
    echo "export RELAY_DOMAINS=..."
    echo "export MAILNAME=..."
    echo "export RELAY_NETWORKS=..."
    echo "export SMARTHOST=..."
    echo "export REDIRECT_TO=..."
    echo "docker run --rm --volumes-from=CONTAINER -i -t IMAGE ..."
    echo "... bash"
    echo "docker run -d -p 25:25 IMAGE"
    echo "... init"
    exit 1
    ;;
esac
