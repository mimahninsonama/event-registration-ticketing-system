##################################################
# Package GET Events Lambda
##################################################

data "archive_file" "get_events_zip" {

  type = "zip"

  source_dir = "${path.module}/../src"

  output_path = "${path.module}/build/get_events.zip"
}