set :output, "cron.log"

every 12.hours do
  rake "backup"
end
