#!/bin/bash

export CS_CONV_BATCH=${1:-ppsobjects1}
export CS_CONV_TYPE=${2:-PastPerfect}
export CS_CONV_PROFILE=${3:-ppsobjectsdata}
export CS_CONV_DOMAIN=${4:-core.collectionspace.org}

echo "Project ${CS_CONV_TYPE}; Batch ${CS_CONV_BATCH}; Profile ${CS_CONV_PROFILE}; Domain ${CS_CONV_DOMAIN}"

bundle exec rake db:import:data[$CS_CONV_BATCH,$CS_CONV_TYPE,$CS_CONV_PROFILE,db/data/${CS_CONV_PROFILE}.csv]
bundle exec rake data:procedure:generate[$CS_CONV_BATCH]
