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






resource "aws_iam_policy" "IO" {
  name = "IO_Policy"
  path = "/"
  description = "Instance Policy, Fetch from S3"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::csuneat-project-2/*",
                "arn:aws:s3:::csuneat-project-2"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "IR" {
  name = "IR_Role"
  path = "/"
  description = "Instance Role, Fetch from S3"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17", 
  "Statement": [
    {
      "Action": "sts:AssumeRole", 
      "Effect": "Allow", 
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
   ]
} 
EOF
}


resource "aws_iam_role_policy_attachment" "Ir-attach" {
    role       = "${aws_iam_role.IR.name}"
    policy_arn = "${aws_iam_policy.IO.arn}"
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
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "ecr:CreateRepository",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ecr:SetRepositoryPolicy",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "arn:aws:ecr:*:*:repository/*"
        }
    ]
}
EOF
}
