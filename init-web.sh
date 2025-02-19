# 특정 컨테이너를 찾기 위한 이미지 이름 또는 ID 패턴
container_pattern="ehddnr7355/roccia-901-web"

# 특정 이미지를 찾기 위한 이름 및 태그
image_repository="ehddnr7355/roccia-901-web"

# 컨테이너 ID 가져오기
container_id=$(sudo docker ps | grep "$container_pattern" | awk '{print $1}')

# 컨테이너가 존재하는지 확인
if [ -n "$container_id" ]; then
  # 컨테이너 중지
  echo "Stopping container $container_id..."
  sudo docker stop "$container_id"

  # 컨테이너 삭제
  echo "Removing container $container_id..."
  sudo docker rm "$container_id"

  echo "Container $container_id stopped and removed."
else
  echo "No container matching pattern '$container_pattern' found."
fi

# 이미지 ID 가져오기
image_id=$(sudo docker images | grep "$image_repository" | awk '{print $3}')

# 이미지가 존재하는지 확인
if [ -n "$image_id" ]; then
  # 이미지 삭제
  echo "Removing image $image_id..."
  sudo docker rmi "$image_id"
else
  echo "No image matching repository '$image_repository' found."
fi

# 사용되지 않는 이미지 정리
echo "Pruning unused images..."
sudo docker image prune -f

# Docker hub에서 이미지 가져오기
sudo docker pull ehddnr7355/roccia-901-web:2.0.0

# 컨테이너 실행
sudo docker run -p 80:80 -p 443:443 \
  -v /var/www/certbot:/var/www/certbot \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  --name flutter-nginx \
  -dt ehddnr7355/roccia-901-web:2.0.0

echo "Script execution completed."
