#!/bin/bash

# includes
. sh_utils # includes fs-config
checkFileExecOrExit pr_init_config
. pr_init_config

scp ${SSH_KEY_LOCATION+ -i ${SSH_KEY_LOCATION}} -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/img ${PRESTA_ROOT}.                                                                                                                                                                                                                                                     
scp ${SSH_KEY_LOCATION+ -i ${SSH_KEY_LOCATION}} -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/download ${PRESTA_ROOT}.                                                                                                                                                                                                                                                
scp ${SSH_KEY_LOCATION+ -i ${SSH_KEY_LOCATION}} -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/upload ${PRESTA_ROOT}.                                                                                                                                                                                                                                                  
scp ${SSH_KEY_LOCATION+ -i ${SSH_KEY_LOCATION}} -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/log ${PRESTA_ROOT}.
