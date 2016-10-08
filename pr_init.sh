#!/bin/bash

[ -x pr_init_config ] || {
    >&2 echo "pr_init_config not found or no execute permissions"
    exit 1;
}

. pr_init_config

# check db config env
[[ -z ${MYSQL_USER} || -z ${MYSQL_PASS} ||
    -z ${PRESTA_ROOT} || -z ${PRESTA_VERSION} || -z ${PRESTA_CREATION_DATE} ||
    -z ${MYSQL_USER} || -z ${MYSQL_PASS} ||
    -z ${SERVER_USER} || -z ${SERVER_HOST} || -z ${SERVER_PATH} ||
    -z ${DB_NAME} || -z ${DB_USER} || -z ${DB_PASS} ||
    -z ${HOST_DOMAIN} || -z ${HOST_PHYS_URI} ||
    -z ${COOKIE_KEY} || -z ${COOKIE_IV} || -z ${RIJNDAEL_KEY} || -z ${RIJNDAEL_IV}]] && 
{
    >&2 echo 'db env not configured'
    exit 4;
}
# check db config env end

[ -f ${PRESTA_ROOT}${DB_IMPORT} ] || {
    >&2 echo "no such file as ${PRESTA_ROOT}${DB_IMPORT}"
    exit 3;
}

read -d '' settings_content << EOF 
<?php
define('_DB_SERVER_', 'localhost');
define('_DB_NAME_', '${DB_NAME}');
define('_DB_USER_', '${DB_USER}');
define('_DB_PASSWD_', '${DB_PASS}');
define('_DB_PREFIX_', 'ps_');
define('_MYSQL_ENGINE_', 'InnoDB');
define('_PS_CACHING_SYSTEM_', 'CacheMemcache');
define('_PS_CACHE_ENABLED_', '0');
define('_COOKIE_KEY_', '${COOKIE_KEY}');
define('_COOKIE_IV_', '${COOKIE_IV}');
define('_PS_CREATION_DATE_', '${PRESTA_CREATION_DATE}');
if (!defined('_PS_VERSION_'))
        define('_PS_VERSION_', '${PRESTA_VERSION}');
define('_RIJNDAEL_KEY_', '${RIJNDAEL_KEY}');
define('_RIJNDAEL_IV_', '${RIJNDAEL_IV}');
EOF

settings_path=${PRESTA_ROOT}'config/settings.inc.php'

[ -f ${settings_path} ] && {
    >&2 echo "${settings_path} already exists"
    exit 2;
}

echo "${settings_content}"  > ${settings_path}

mysql -u ${MYSQL_USER} -p${MYSQL_PASS} << EOF
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT USAGE ON *.* to '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
EOF

mysql -u ${DB_USER} -p${DB_PASS} ${DB_NAME} < ${PRESTA_ROOT}${DB_IMPORT}

mysql -u ${MYSQL_USER} -p${MYSQL_PASS} << EOF
USE ${DB_NAME};
UPDATE ps_shop_url SET domain='${HOST_DOMAIN}', domain_ssl='${HOST_DOMAIN}', physical_uri='${HOST_PHYS_URI}' WHERE id_shop_url=1;
EOF

scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/img ${PRESTA_ROOT}.
scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/download ${PRESTA_ROOT}.
scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/upload ${PRESTA_ROOT}.
scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/log ${PRESTA_ROOT}.

echo "don't forget to set permissions
Example:
cd ${PRESTA_ROOT}../
sudo chown -R www-data:www-data sammuke"
