resource "aws_dynamodb_table" "create_visitor_table" {
  name           = "visitor"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "website_name"
  attribute {
    name = "website_name"
    type = "S"
  }





    
}

resource "aws_dynamodb_table_item" "create_vistor_counter_item" {
  table_name = aws_dynamodb_table.create_visitor_table.name
  hash_key   = aws_dynamodb_table.create_visitor_table.hash_key
  item       = <<ITEM
{
    "website_name" : {"S" : "cloud_resume"},
    "visitor_counter": {"N": "0"}
}
ITEM

# Ignore updates to the counter so Terraform doesn' try to reset the value after every "terraform apply" 
# Feels a little hacky to me, will research a better solution.
  lifecycle { 
  ignore_changes = [item]
}
}



