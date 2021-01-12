#! /bin/bash

# service_url.inc 에서 현재 서비스를 하고 있는 WAS의 포트 번호를 읽어옵니다.
CURRENT_PORT=$(cat /home/ubuntu/service_url.inc | grep -Po '[0-9]+' | tail -1) T
ARGET_PORT=0

echo "> Current port of running WAS is ${CURRENT_PORT}."

# 현재 포트 번호가 8081이면 새로 WAS를 띄울 타겟 포트는 8082, 혹은 그 반대 상황이라면 8081을 지정합니다.
if [ ${CURRENT_PORT} -eq 8081 ]; then
  TARGET_PORT=8082
elif [ ${CURRENT_PORT} -eq 8082 ]; then
  TARGET_PORT=8081
else
  echo "> No WAS is connected to nginx"
fi

# 만약 타겟포트에도 WAS가 떠 있다면 kill하고 새롭게 WAS를 띄웁니다.
TARGET_PID=$(lsof -Fp -i TCP:${TARGET_PORT} | grep -Po 'p[0-9]+' | grep -Po '[0-9]+')

if [ ! -z ${TARGET_PID} ]; then
  echo "> Kill WAS running at ${TARGET_PORT}."
  sudo kill -15 ${TARGET_PID}
fi

# nohup -> 터미널 엑세스가 끊겨도 실행한 프로세스가 계속 동작하게 합니다.
# 마지막의 &는 프로세스가 백그라운드로 실행되도록 해줍니다.
nohup java -jar -Dserver.port=${TARGET_PORT} /home/ubuntu/githubActionTest/build/libs/* > /home/ubuntu/nohup.out 2>&1 &
echo "> Now new WAS runs at ${TARGET_PORT}."
exit 0
