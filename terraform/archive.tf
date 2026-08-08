##################################################
# Package GET Events Lambda
##################################################

data "archive_file" "get_events_zip" {

  type = "zip"

  source_dir = "${path.module}/../src"

  output_path = "${path.module}/build/get_events.zip"
}
##################################################
# Register Event Lambda Package
##################################################

data "archive_file" "register_event_zip" {

  type = "zip"

  source_dir = "${path.module}/../src"

  output_path = "${path.module}/build/register_event.zip"
}
##################################################
# Get Registrations Lambda Package
##################################################

data "archive_file" "get_registrations_zip" {

  type = "zip"

  source_dir = "${path.module}/../src"

  output_path = "${path.module}/build/get_registrations.zip"
}
#Delete Registered Event Lambda Package
data "archive_file" "delete_registration_zip" {

  type = "zip"

  source_dir = "${path.module}/../src"

  output_path = "${path.module}/build/delete_registration.zip"
}