import boto3

#Create the boto3 client
ssm = boto3.client('ssm')

#Aside from the database name dynamodb, all other values are pulled out of the Parameter Store
database        = 'dynamodb'
table           = ssm.get_parameter(Name='dynamodb_table',WithDecryption=True)
hash_key_column = ssm.get_parameter(Name='dynamodb_hash_key',WithDecryption=True)
hash_key_value  = ssm.get_parameter(Name='dynamodb_hash_key_value',WithDecryption=True)
hash_key_count  = ssm.get_parameter(Name='dynamodb_table_column',WithDecryption=True)