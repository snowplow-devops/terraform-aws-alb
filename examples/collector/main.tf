variable "vpc_id" {
  description = "The VPC to deploy the load balancer within"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnets to deploy the load balancer across"
  type        = list(string)
}

module "lb" {
  source = "../../"

  name              = "collector-lb"
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  health_check_path = "/health"
}

output "id" {
  value = module.lb.id
}

output "dns_name" {
  value = module.lb.dns_name
}
