#Create the dynamodb table, must include the hash key as the Primary key value
resource "aws_dynamodb_table" "create_visitor_table" {
  name           = data.aws_ssm_parameter.dynamodb_table.value
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = data.aws_ssm_parameter.dynamodb_hash_key.value
  attribute {
    name = data.aws_ssm_parameter.dynamodb_hash_key.value
    type = "S"
  }
}

#Create the visitor counter fields and populate with initial values 
resource "aws_dynamodb_table_item" "create_vistor_counter_item" {
  table_name = aws_dynamodb_table.create_visitor_table.name
  hash_key   = aws_dynamodb_table.create_visitor_table.hash_key
  item       = jsondecode(data.aws_ssm_parameter.table_item.value)

  #  <<ITEM
  #{
  #    ${data.aws_ssm_parameter.dynamodb_hash_key.value} : {"S" : ${data.aws_ssm_parameter.dynamodb_hash_key_value.value}},
  #    ${data.aws_ssm_parameter.dynamodb_table_column.value}: {"N": "0"}
  #}
  #ITEM

  #Ignore updates to the counter so Terraform doesn't try to reset the value 
  #after every "terraform apply." Feels a little hacky to me, will research a better solution.
  lifecycle {
    ignore_changes = [item]
  }
}