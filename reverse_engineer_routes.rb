#####
# Find out what the controller, action, id, etc for a given route is...
#
# Useful for trying to write links.
#####

# From the Rails console
Rails.application.routes.recognize_path('/insert/path/here')

# Result will be similar to the below based off of how the route is built in the routes file.
# => {:controller=>"insert", :action=>"path", :id=>"here"}
