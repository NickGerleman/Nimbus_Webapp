require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(2.minutes, 'Remove Expired Sessions') { RemoveExpiredSessionsWorker.perform_async }
every(3.minutes, 'Fail old dropbox sessions') { FailDropboxConnectionsWorker.perform_async }
every(1.day, 'Remove Unvalidated Users') { RemoveUnverifiedUsersWorker.perform_async }