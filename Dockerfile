#Выбираем базовый образ
FROM ubuntu:latest
#Выполняем обновление apt-кеша
RUN apt-get update
#Обновляем все пакеты в контейнере
RUN apt-get upgrade -y
#Установить сервер nginx
RUN apt-get install -y nginx
#Удаляю apt кэш
RUN apt-get clean
#Удаляю содержимое директории /var/www/
RUN rm -rf /var/www/*
#Помещаю из папки в докер контейнер index.html
RUN mkdir -p /var/www/antipov/
COPY index.html /var/www/antipov
#Помещаю из папки в докер контейнер img.jpg
RUN mkdir -p /var/www/antipov/img
COPY img.jpg /var/www/antipov/img
#Задать рекурсивно на папку права владельцу - Ч,П,И группе - Ч,И остальным - Ч,И
RUN chmod -R 755 /var/www/antipov
# С помощью команды useradd создать пользователя
RUN useradd testdock
# С помощью команды groupadd создать группу
RUN groupadd iris
# Поместить пользователя в группу
RUN usermod -a -G iris testdock
# Рекурсивно присвоить созданных пользователя и группу на папку
RUN chown -R testdock:iris /var/www/antipov
# Заменяем значение /var/www/html в файле
RUN sed -i 's/\/var\/www\/html/\/var\/www\/antipov/g' /etc/nginx/sites-enabled/default
# Ищем пользователя от которого запускается nginx
# grep -r "user" /etc/nginx
# С помощью команды sed заменить пользователя ngix на нашего
RUN sed -i 's/www-data/testdock/g' /etc/nginx/nginx.conf
# Задать порты подключения
EXPOSE 80
#Запускаем nginx при запуске контейнера
CMD ["nginx","-g","daemon off;"]
LABEL authors="artemantipov"
LABEL description="Простой веб-сервер nginx на ubuntu"