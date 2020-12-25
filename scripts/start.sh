#!/bin/sh

DATABASE=$(jq -r '.Dhcp4."lease-database"' /etc/kea/kea-dhcp4.conf)
TYPE=$(echo "$DATABASE" | jq -r '.type')
DBHOST=$(echo "$DATABASE" | jq -r '.host')
USER=$(echo "$DATABASE" | jq -r '.user')
PASS=$(echo "$DATABASE" | jq -r '.password')
NAME=$(echo "$DATABASE" | jq -r '.name')

echo "Using $TYPE as lease database"

while ! nc -z $DBHOST 3306; do
    sleep 5s
    echo "Waiting for MariaDB..."
done

if [ -z $DBINITED ];then
case "$TYPE" in
    "mysql"|"pgsql")
        kea-admin db-init ${TYPE} -u ${USER} -p ${PASS} -n ${NAME} -h ${DBHOST}
        export DBINITED=1
    ;;
    "cql")
        kea-admin db-init ${TYPE} -n ${NAME}
        export DBINITED=1
    ;;
esac
fi

kea-dhcp4 -c /etc/kea/kea-dhcp4.conf
