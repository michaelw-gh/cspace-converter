#!/bin/bash

export CSPACE_CONVERTER_TYPE=${CSPACE_CONVERTER_TYPE:-PastPerfect}
export CSPACE_CONVERTER_PROFILE=${CSPACE_CONVERTER_PROFILE:-ppsobjectsdata}

echo "Setting up project for ${CSPACE_CONVERTER_TYPE} with profile ${CSPACE_CONVERTER_PROFILE}"

bundle exec rake db:import:data[db/data/${CSPACE_CONVERTER_PROFILE}.csv]
bundle exec rake data:procedure:generate[${CSPACE_CONVERTER_PROFILE}]
