set :environment, "development"
set :output, "log/cron_log.log"
ENV.each { |k, v| env(k, v) }

every 1.minute do
  rake "jobs:workoff"
end
