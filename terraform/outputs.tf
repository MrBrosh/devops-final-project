output "public_ip" {
  description = "Public IP of the web instance"
  value       = aws_instance.web.public_ip
}

output "inventory_path" {
  description = "Path to generated Ansible inventory.ini"
  value       = local_file.ansible_inventory.filename
}

