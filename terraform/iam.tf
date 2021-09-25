#Create lambda policy to restrict to one dynamodb table for only PUTs, GETs, and UPDATEs
resource "aws_iam_policy" "GetUpdateVisitorsPolicy" {
  name        = "GetUpdateVisitorsPolicy"
  description = "GetUpdateVisitorsPolicy"

  policy = <<POL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetUpdateVisitorsPolicy",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem",
                "dynamodb:UpdateItem"
            ],
            "Resource": "arn:aws:dynamodb:${data.aws_ssm_parameter.my_region.value}:${data.aws_ssm_parameter.account_id.value}:table/${data.aws_ssm_parameter.dynamodb_table.value}"
        }
    ]
}
POL
}

#Attach Lambda policy to role for Lambda function call
resource "aws_iam_role_policy_attachment" "lambda-role-attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.GetUpdateVisitorsPolicy.arn
}