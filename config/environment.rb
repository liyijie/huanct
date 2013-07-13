# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Huanct::Application.initialize!

scheduler = Rufus::Scheduler.start_new
scheduler.every '10m', :first_in => '1s', :allow_overlapping => false do |job|
  CommentsController.refresh
end