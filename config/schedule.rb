# Learn more: http://github.com/javan/whenever

set :output, "log/whenever.log"

every 1.day, at: '00:01 am' do
  runner "DailyDigestJob.perform_now"
  # runner "DailyDigestJob.perform_now", environment: "development"
end
