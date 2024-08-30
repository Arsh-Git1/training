resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"
  ...
}

resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn  = aws_iam_policy.AmazonEC2FullAccess.arn
}
