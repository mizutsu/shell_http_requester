#!/usr/bin/env bash

declare -r URL=$1
declare -r PROXY_SERVER=''
declare -r PROXY_PORT=''
declare -r OUTPUT_FILE_NAME='api_response'
declare -r COLOR_RED="\e[33;41;1m"
declare -r COLOR_BLUE="\e[33;44;1m"
declare -r COLOR_YELLOW="\e[31;43;1m"
declare -r COLOR_OFF="\e[m"


# Skip comment lines
case "${URL}" in
  http*)
    :
    ;;
  *)
    exit 0
    ;;
esac


if [ -z "${PROXY_SERVER}" ]; then
  # cURL
  http_status_code=$(curl -X GET -Ss ${URL} -w "%{http_code}" -o ${OUTPUT_FILE_NAME})
else
  # cURL by using proxy
  http_status_code=$(curl --proxy ${PROXY_SERVER}:${PROXY_PORT} -X GET -Ss ${URL} -w "%{http_code}" -o ${OUTPUT_FILE_NAME})
fi

if [ $? = 0 ]; then
  case "${http_status_code}" in
    2??)
      echo -e "${COLOR_BLUE}[HTTP Status Code] ${http_status_code} ${COLOR_OFF}"
      ;;
    4??)
      echo -e "${COLOR_RED}[HTTP Status Code] ${http_status_code} ${COLOR_OFF}"
      ;;
    *)
      echo -e "${COLOR_YELLOW}[HTTP Status Code] ${http_status_code} ${COLOR_OFF}"
      ;;
  esac
  
  exit 0
else
  echo -e "${COLOR_RED}Failed to curl. ${COLOR_OFF}"
  exit 1
fi
