resource "aws_iam_role" "arsh_ec2_role" {
  name = "arsh-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "arsh-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "arsh_ec2_policy_attachment" {
  role       = aws_iam_role.arsh_ec2_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}