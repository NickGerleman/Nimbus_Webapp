require 'clockwork'
require 'syslog/logger'

Clockwork.configure {|config| config[:logger] = Syslog::Logger.new('clockwork')}

require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)


include Clockwork

every(2.minutes, 'Remove Expired Sessions') { RemoveExpiredSessionsWorker.perform_async }
every(2.minutes, 'Fail Hung Connection Attempts') { FailHungServicesWorker.perform_async }
every(1.day, 'Remove Unvalidated Users') { RemoveUnverifiedUsersWorker.perform_async }
