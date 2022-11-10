#!/bin/bash

NUMCPUS=`grep processor < /proc/cpuinfo | wc -l`

if [ -z "$1" ] ; then
      NUMINSTANCES=2
else
      echo $1 | grep "^[0-9]*$" >/dev/null
      if [ "$?" -ne 0 ] ; then
            echo Argument $1 is not a number. Aborting.
            exit 1
      else
            if [ "$1" -gt "$NUMCPUS" ] ; then
                  echo Want to start more instances than CPUs available? Very
                  echo brave. Type yes to continue.
                  read answer
                  if [ "$answer" != "yes" ] ; then
                        echo Wise answer, my young padawan. Aborting.
                        exit 2
                  fi
                  echo Good luck and have a lot of fun...
            fi
            NUMINSTANCES=$1
      fi
fi

for ((i=1; i<=$NUMINSTANCES; i++)) ; do
      echo Starting instance $i...
      openssl speed &
      instances[$i]=$!
done

echo Waiting for processes to finish...
waitlist=""
for ((i=1; i<=$NUMINSTANCES; i++)) ; do
      waitlist="${instances[$i]} $waitlist"
done
trap "kill $waitlist" SIGINT SIGTERM
wait $waitlist

echo All processes finished.
