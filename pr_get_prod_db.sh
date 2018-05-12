# copies production database to development database
# on server: give grant to user for your development wan ip

#!/bin/bash

# includes
. sh_utils # includes fs-config
checkFileExecOrExit pr_init_config
. pr_init_config

mysqldump -h ${PROD_SERVER} -u ${PROD_DB_USER} -p${PROD_DB_PASS} ${PROD_DB_NAME} | mysql -h ${DEV_SERVER} -u ${DEV_DB_USER} -p${DEV_DB_PASS} ${DEV_DB_NAME}

mysql -h ${DEV_SERVER} -u ${DEV_DB_USER} -p${DEV_DB_PASS} << EOF
USE ${DEV_DB_NAME};
UPDATE ps_shop_url SET domain='${DEV_DB_HOST_DOMAIN}', domain_ssl='${DEV_DB_HOST_DOMAIN}', physical_uri='${DEV_DB_HOST_PHYS_URI}' WHERE id_shop_url=1;
EOF
