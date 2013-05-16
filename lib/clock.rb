require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(2.minutes, 'Remove Expired Sessions') { RemoveExpiredSessionsWorker.perform_async }
every(1.day, 'Remove Unvalidated Users') { RemoveUnverifiedUsersWorker.perform_async }
every(20.minutes, 'Stop From Idling') do
  uri = URI.parse('htts://nimbus-web.herokuapp.com/')
  Net::HTTP.get(uri)
end