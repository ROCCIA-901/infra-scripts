# 로그 디렉토리가 존재하는지 확인
mkdir -p /var/log/certbot

# certbot 갱신을 실행하고 출력을 로그에 기록
sudo docker run --rm \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  -v /var/www/certbot:/var/www/certbot \
  certbot/certbot renew --webroot -w /var/www/certbot --quiet --no-self-upgrade >> /var/log/certbot/certbot-renew.log 2>&1

if [ $? -eq 0 ]; then
  echo "$(date) - Certbot renew succeeded" >> /var/log/certbot/certbot-renew.log
  # Nginx 설정을 리로드하고 출력을 로그에 기록
  sudo docker exec flutter-nginx nginx -s reload >> /var/log/certbot/nginx-reload.log 2>&1
  if [ $? -eq 0 ]; then
    echo "$(date) - Nginx reload succeeded" >> /var/log/certbot/nginx-reload.log
  else
    echo "$(date) - Nginx reload failed" >> /var/log/certbot/nginx-reload.log
  fi
else
  echo "$(date) - Certbot renew failed" >> /var/log/certbot/certbot-renew.log
fi
