require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

#Write pid file
File.open('/tmp/clockwork.pid', 'w') {|f| f.write(Process.pid)}

include Clockwork

every(2.minutes, 'Remove Expired Sessions') { RemoveExpiredSessionsWorker.perform_async }
every(2.minutes, 'Fail Hung Connection Attempts') { FailHungServicesWorker.perform_async }
every(1.day, 'Remove Unvalidated Users') { RemoveUnverifiedUsersWorker.perform_async }
