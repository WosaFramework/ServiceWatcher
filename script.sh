#!/bin/bash
SERVER_ADDRESS="http://31.208.6.69/snail.html"
WEBHOOK_URL="webhook_here"
OFFLINE_CACHE=false

while true;do
   if curl --connect-timeout 10 -I $SERVER_ADDRESS 2>&1 | grep -w "200"; then
      if [ $OFFLINE_CACHE = true ]; then
         OFFLINE_CACHE=false

         curl -X POST \
         -H "Accept: application/json" \
         -H "Content-Type:application/json; charset=utf-8" \
         -d '{"content": ":white_check_mark: Wosa *services* is now back online and operational again."}' \
         ${WEBHOOK_URL}

         echo "Wosa services is now running and is online again."
      else
         echo "Wosa services running & operating normally."
      fi
   else
      echo $OFFLINE_CACHE
      if [ $OFFLINE_CACHE = false ]; then
         OFFLINE_CACHE=true

         curl -X POST \
         -H "Accept: application/json" \
         -H "Content-Type:application/json; charset=utf-8" \
         -d '{"content": ":warning: Wosa *service server* is currently **offline** meaning authentication is unavailable in the current moment. Rest assured that we are looking into the problem."}' \
         ${WEBHOOK_URL}

         echo "Wosa services just went offline, posting message."
      fi
   fi

   sleep 10s
done