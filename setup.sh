#!/bin/bash

export CSPACE_CONVERTER_TYPE=${CSPACE_CONVERTER_TYPE:-PastPerfect}
export CSPACE_CONVERTER_PROFILE=${CSPACE_CONVERTER_PROFILE:-ppsobjectsdata}
export CSPACE_CONVERTER_DOMAIN=${CSPACE_CONVERTER_DOMAIN:-core.collectionspace.org}

echo "Project ${CSPACE_CONVERTER_TYPE}; Profile ${CSPACE_CONVERTER_PROFILE}; Domain ${CSPACE_CONVERTER_DOMAIN}"

bundle exec rake db:import:data[db/data/${CSPACE_CONVERTER_PROFILE}.csv]
bundle exec rake data:procedure:generate[${CSPACE_CONVERTER_PROFILE}]
