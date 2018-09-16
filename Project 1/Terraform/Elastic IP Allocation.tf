resource "aws_eip" "lb" {
  instance = "i-067add47de25e0088"
  vpc      = true
}