#!/bin/bash

[ -x pr_init_config ] || {
    >&2 echo "pr_init_config not found or no execute permissions"
    exit 1;
}

. pr_init_config

scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/img ${PRESTA_ROOT}.                                                                                                                                                                                                                                                     
scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/download ${PRESTA_ROOT}.                                                                                                                                                                                                                                                
scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/upload ${PRESTA_ROOT}.                                                                                                                                                                                                                                                  
scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/log ${PRESTA_ROOT}.
