output "runner_instance_id" {
  value = aws_instance.runner.id
}

output "runner_public_ip" {
  value = aws_instance.runner.public_ip
}

output "runner_sg_id" {
  value = aws_security_group.runner.id
}
