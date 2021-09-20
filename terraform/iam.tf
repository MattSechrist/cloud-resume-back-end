#create lambda policy to restrict to one table
#make sure lamda_role attached to lamda function
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
            "Resource": "arn:aws:dynamodb:${var.my_region}:${var.account_id}:table/${var.dynamodb_table}"
        }
    ]
}
POL
}

resource "aws_iam_role_policy_attachment" "lambda-role-attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.GetUpdateVisitorsPolicy.arn
}


