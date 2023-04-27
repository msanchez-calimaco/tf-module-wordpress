resource "aws_efs_file_system" "my_efs" {
  creation_token   = "${var.nickname}-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name  = "${var.environment}-MyEFS"
    stage = "${var.environment}"
    Owner = "${var.your_name}"
  }
}
resource "aws_efs_mount_target" "efs-mt-A" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = module.vpc.intra_subnets[0]
  security_groups = ["${aws_security_group.efs-sg.id}"]
}
resource "aws_efs_mount_target" "efs-mt-B" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = module.vpc.intra_subnets[1]
  security_groups = ["${aws_security_group.efs-sg.id}"]
}