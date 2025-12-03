output "gitlab_instance_id" {
  value = aws_instance.gitlab.id
}

output "gitlab_public_ip" {
  value = aws_instance.gitlab.public_ip
}

output "gitlab_sg_id" {
  value = aws_security_group.gitlab.id
}
