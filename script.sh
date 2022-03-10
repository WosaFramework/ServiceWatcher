#!/bin/bash
SERVER_ADDRESS="http://31.208.6.69/snail.html"
WEBHOOK_URL="webhook_url_here_secret"
INFO_HANDLER="https://raw.githubusercontent.com/WosaFramework/ServiceWatcher/main/info.json"
OFFLINE_CACHE=false

while true;do
   if curl --connect-timeout 1 -I $SERVER_ADDRESS 2>&1 | grep -w "200"; then
      if [ $OFFLINE_CACHE = true ]; then
         OFFLINE_CACHE=false

         ONLINE_SERVICE_MESSAGE=$(curl https://raw.githubusercontent.com/WosaFramework/ServiceWatcher/main/info.json | jq '.KNOWN_ONLINE_REASON')
         ONLINE_SERVICE_MESSAGE=`sed -e 's/^"//' -e 's/"$//' <<<"$ONLINE_SERVICE_MESSAGE"`

         ONLINE_MESSAGE=":white_check_mark: Wosa *services* is now back online and operational again."
         FULL_MESSAGE=""
         SERVICE_HEADER="\n\n:notepad_spiral:"

         if [ "$ONLINE_SERVICE_MESSAGE" != "NONE" ]; then
            FULL_MESSAGE="${ONLINE_MESSAGE} ${SERVICE_HEADER} ${ONLINE_SERVICE_MESSAGE}"
         else
            FULL_MESSAGE=$ONLINE_MESSAGE
         fi

         ./discord.sh --webhook-url=$WEBHOOK_URL --text "$FULL_MESSAGE"

         echo "Wosa services is now running and is online again."
      else
         echo "Wosa services running & operating normally."
      fi
   else
      if [ $OFFLINE_CACHE = false ]; then
         OFFLINE_CACHE=true

         OFFLINE_SERVICE_MESSAGE=$(curl https://raw.githubusercontent.com/WosaFramework/ServiceWatcher/main/info.json | jq '.ONLINE_REPORT')
         OFFLINE_SERVICE_MESSAGE=`sed -e 's/^"//' -e 's/"$//' <<<"$OFFLINE_SERVICE_MESSAGE"`

         OFFLINE_MESSAGE=":warning: Wosa *service server* is currently **offline** meaning authentication is unavailable in the current moment."
         FULL_MESSAGE=""
         SERVICE_HEADER="\n\n:notepad_spiral:"

         if [ "$OFFLINE_SERVICE_MESSAGE" != "NONE" ]; then
            FULL_MESSAGE="${OFFLINE_MESSAGE} ${SERVICE_HEADER} ${OFFLINE_SERVICE_MESSAGE}"
         else
            FULL_MESSAGE=$OFFLINE_MESSAGE
         fi

         ./discord.sh --webhook-url=$WEBHOOK_URL --text "$FULL_MESSAGE"

         echo "Wosa services just went offline, posting message."
      fi
   fi

   sleep 10s
done