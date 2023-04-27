# Creating controller node
resource "aws_instance" "mariadb" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[1]
  vpc_security_group_ids = ["${aws_security_group.MySQL-sg.id}"]
  user_data  = data.template_file.bootstrap-db.rendered
  monitoring = true
  key_name   = var.key
  depends_on = [aws_efs_file_system.my_efs]
 
  tags = {
    Name  = "${var.environment}-MariaDB"
    Stage = "${var.environment}"
    Owner = "${var.your_name}"
  }
}
 
data "template_file" "bootstrap-db" {
  template = file("bootstrap_mariadb.tpl")
  vars = {
    efs_id        = "${aws_efs_file_system.my_efs.id}"
    root_password = var.root_password
    user          = var.user
    password      = var.password
    dbname        = var.dbname
  }
}