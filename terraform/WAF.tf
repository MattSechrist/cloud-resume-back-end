#create WebACL
#block when no rules are found by default
#Create both rules - 5 free default rules, 1 created by me
#turn off at appsync
#attach to appsync - appsync_visitor_counter_api
#turn on bot control

#Turned this as it was too expensive and not really necessary - I wanted to learn how to block Introspection and nested queries. 
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