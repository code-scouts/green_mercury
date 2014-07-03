#! /bin/bash

curl -X POST -d client_id=$CLIENT_ID -d client_secret=$CLIENT_SECRET -d type_name=user --data-urlencode attr_def='{"name":"coc_accepted_date","type":"date"}' https://codescouts$DEV.janraincapture.com/entityType.addAttribute
