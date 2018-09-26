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

data "aws_iam_policy" "policy" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "attach-policy" {
  group = "${aws_iam_group.Eat-Team.name}"
  policy_arn = "${data.aws_iam_policy.policy.arn}"
}
