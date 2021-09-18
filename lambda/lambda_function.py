import boto3
import json
import lambda_variables

#Get the dynamodb resource and table
dynamodb = boto3.resource(lambda_variables.database)
table    = dynamodb.Table(lambda_variables.table)    

#Initializes and increments the visitor counter value by 1
def update_visitor_counter():
    response = table.update_item(Key={lambda_variables.hash_key_column: lambda_variables.hash_key_value},
    AttributeUpdates={
            hash_key_count: {
                'Value': 1,
                'Action': 'ADD'
            }
        }
    )        

#This function calls update_visitor_counter() which initializes/increments the visitor counter, 
# then returns the current visitor counter value    
def get_visitor_counter(event, context):
    update_visitor_counter()
    
    response = table.get_item(Key={lambda_variables.hash_key_column: lambda_variables.hash_key_value})

    apiResponse = {
        "isBase64Encoded": False,
        "statusCode": 200,
        'headers': {
            'Access-Control-Allow-Headers': 'content-type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS, POST, GET'
        },
        "body": response['Item'].get(hash_key_count)
    }
    return apiResponse

#Calls   get_visitor_counter() to update&return the visitor counter  
if __name__ == '__main__':
    get_visitor_counter(event, context)
    