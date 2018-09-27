provider "aws" {
  region     = "us-west-2"
}

resource "aws_iam_group" "Eat-Team" {
  name = "EAT-Team"
}

resource "aws_iam_user" "Alex"{
  name = "Alex"
}

resource "aws_iam_user" "Erik"{
  name = "Erik"
}

resource "aws_iam_user" "TK"{
  name = "TK"
}

resource "aws_iam_user" "Brian"{
  name = "Brian"
}

resource "aws_iam_user" "Shahid"{
  name = "Shahid"
}

resource "aws_iam_user" "CircleCI"{
  name = "CircleCI"
}

resource "aws_iam_group_membership" "EAT-Membership" {
  name = "Adding-members-to-EAT"

  users = [
    "${aws_iam_user.Alex.name}",
    "${aws_iam_user.Erik.name}",
   	"${aws_iam_user.Brian.name}",
	  "${aws_iam_user.TK.name}",
    "${aws_iam_user.Shahid.name}"
  ]

  group = "${aws_iam_group.Eat-Team.name}"
}

resource "aws_iam_group_policy_attachment" "attach-policy" {
  group = "${aws_iam_group.Eat-Team.name}"
  policy_arn = "${data.aws_iam_policy.policy.arn}"
}



resource "aws_iam_group" "Bots" {
  name = "Bots"
}

resource "aws_iam_group_membership" "Bot-Membership" {
  name = "Adding-members-to-Bots"

  users = [
    "${aws_iam_user.CircleCI.name}"
  ]

  group = "${aws_iam_group.Bots.name}"
}

resource "aws_iam_group_policy_attachment" "attach-bot-policy" {
  group = "${aws_iam_group.Bots.name}"
  policy_arn = "${aws_iam_policy.PO.arn}"
}




data "aws_iam_policy" "policy" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "PO" {
  name = "PO_Policy"
  path = "/"
  description = "Bot Policy, Upload to S3"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
         "Sid": "Stmt15807183600",
         "Effect": "Allow",
         "Action": [
               "s3:PutObject" 
         ],
         "Resource": [
               "*"
         ]
     }
  ]
}
EOF
}
