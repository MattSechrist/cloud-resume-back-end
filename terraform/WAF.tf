# Disabled this tf file as it was too expensive and not really necessary - I wanted to learn how to block Introspection and nested queries. 
# I used the 6 standard free Managed ACL rules, along with my own custom AppSync-query specific rule shown below:
# Ultimately with API Gateway, I was able to meet my most pressing security concern of throttling requests.

#visitor_counter rule JSON
#
# "Name": "visitor_counter",
# "Priority": 0,
# "Statement": {
#   "ByteMatchStatement": {
#     "SearchString": "{visitor_counter{body}}",
#     "FieldToMatch": {
#       "JsonBody": {
#         "MatchPattern": {
#           "All": {}
#         },
#         "MatchScope": "ALL"
#       }
#     },
#     "TextTransformations": [
#       {
#         "Priority": 6,
#         "Type": "NONE"
#       }
#     ],
#     "PositionalConstraint": "EXACTLY"
#   }
# },
# "Action": {
#   "Allow": {}
# },
# "VisibilityConfig": {
#   "SampledRequestsEnabled": true,
#   "CloudWatchMetricsEnabled": true,
#   "MetricName": "visitor_counter"
# }
#