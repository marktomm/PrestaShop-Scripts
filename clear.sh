#!/bin/bash



# includes
. sh_utils # includes fs-config

checkFileExecOrExit pr_init_config

. pr_init_config
# includes end



# check db config env
[[ -z ${PRESTA_ROOT} || 
   -z ${MYSQL_USER} || -z ${MYSQL_PASS} ||
   -z ${DB_SERVER} || -z ${DB_NAME} || 
   -z ${DB_USER} || -z ${DB_PASS} ]] &&
{
    log_err 'db env not configured'
}
# check db config env end



# ask this
to_stdout "Do you wish to clear local db?"
read -r -p "Are you sure? [y/N] " response
[[ $response =~ ^([yY][eE][sS]|[yY])$ ]] || { exit 1; }
# ask this end



# mysql interactions
mysql -u ${MYSQL_USER} -p${MYSQL_PASS} << EOF
DROP DATABASE IF EXISTS ${DB_NAME};
DROP USER '${DB_USER}'@'${DB_SERVER}';
EOF

checkMysqlResponse $?
#mysql interactions end

evalOkOrExit "rm ${PRESTA_ROOT}config/settings.inc.php"

to_stdout "All OK with db drop"