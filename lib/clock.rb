require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(5.minutes, 'Remove Expired Sessions') { Delayed::Job.enqueue RemoveExpiredJob.new }
every(1.week, 'Remove Unvalidated Users') { Delayed::Job.enqueue RemoveUnvalidatedJob.new }