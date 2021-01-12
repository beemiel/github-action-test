#! /bin/bash

# service_url.inc 에서 현재 서비스를 하고 있는 WAS의 포트 번호를 읽어옵니다.
CURRENT_PORT=$(cat /home/ubuntu/service_url.inc | grep -Po '[0-9]+' | tail -1)
TARGET_PORT=0

echo "> Current port of running WAS is ${CURRENT_PORT}."

# 사실 지금은 이것도 필요없다. 그냥 kill했다가 다시 올리기만 하면 되니까..
# 현재 포트 번호가 8081이면 새로 WAS를 띄울 타겟 포트는 8082, 혹은 그 반대 상황이라면 8081을 지정합니다.
if [ ${CURRENT_PORT} -eq 8081 ]; then
  TARGET_PORT=8082
elif [ ${CURRENT_PORT} -eq 8082 ]; then
  TARGET_PORT=8081
else
  echo "> No WAS is connected to nginx"
fi

# 기존거는 죽여버려
# 중간에는 프로젝트 제목이니까 잘 바꿔주자
CURRENT_PID=$(ps -ef | grep githubActionTest | grep java | awk '{print $2}')
sudo kill -15 ${CURRENT_PID}

# 새로 어플리케이션 실행
nohup java -jar /home/ubuntu/githubActionTest/build/libs/* > /home/ubuntu/nohup.out 2>&1 &
echo "> Now new WAS runs."

