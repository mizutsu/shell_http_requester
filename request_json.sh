#!/usr/bin/env bash

declare -r URL=$1
declare -r METHOD=$2
declare -r JSON=$3
declare -r PROXY_SERVER=''
declare -r PROXY_PORT=''
declare -r OUTPUT_FILE='response.json'
declare -r COLOR_BLUE="\e[33;44;1m"
declare -r COLOR_OFF="\e[m"

# Skip comment lines
case "${JSON}" in
  '{'*)
    :
    ;;
  *)
    exit 0
    ;;
esac

if [ -z "${PROXY_SERVER}" ]; then
  # cURL
  http_status_code=$(curl \
    -X ${METHOD} \
    -H 'Content-Type:application/json' -d "${JSON}" -s "${URL}" \
    -w "%{http_code}\n" -o ${OUTPUT_FILE})
else
  # cURL by using proxy
  http_status_code=$(curl \
    -X ${METHOD} \
    --proxy ${PROXY_SERVER}:${PORT} \
    -H 'Content-Type:application/json' -d "${JSON}" -s "${URL}" \
    -w "%{http_code}\n" -o ${OUTPUT_FILE})
fi

echo -e "${COLOR_BLUE}http_status_code${COLOR_OFF}"
echo "${http_status_code}"
echo -e "${COLOR_BLUE}response body${COLOR_OFF}"
cat ${OUTPUT_FILE} | python -m json.tool

exit 0
