resource "aws_key_pair" "ssh" {
  key_name   = "demo-key"
  public_key = file("~/.ssh/aws_keys/id_ed25519.pub")
}