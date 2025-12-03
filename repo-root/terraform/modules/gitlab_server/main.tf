############################
# AMI (Ubuntu 22.04)
############################
data "aws_ami" "ubuntu_2204" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

############################
# Security Group
############################
resource "aws_security_group" "gitlab" {
  name        = "${var.project_name}-gitlab-sg"
  description = "GitLab HTTP/HTTPS/SSH access"
  vpc_id      = var.vpc_id

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH (관리자용)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_admin_cidr]
  }

  # Git over SSH (컨테이너 2222 → EC2 2222)
  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-gitlab-sg"
  }
}

############################
# IAM Role for SSM
############################
resource "aws_iam_role" "this" {
  name = "${var.project_name}-gitlab-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.project_name}-gitlab-profile"
  role = aws_iam_role.this.name
}

############################
# GitLab EC2 Instance
############################
resource "aws_instance" "gitlab" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.gitlab.id]

  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = true

  # 키페어는 선택 옵션
  key_name = var.key_name != "" ? var.key_name : null

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
  }

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    gitlab_hostname = var.gitlab_hostname
  })

  tags = {
    Name = "${var.project_name}-gitlab"
    Role = "gitlab"
  }
}
