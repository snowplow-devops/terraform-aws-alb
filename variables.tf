variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "vpc_id" {
  description = "The VPC to deploy the load balancer within"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnets to deploy the load balancer across"
  type        = list(string)
}

variable "egress_port" {
  description = "The port that the downstream webserver exposes over HTTP"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "The path to bind for health checks"
  type        = string
}

variable "matcher" {
  description = "The response codes expected for health checks"
  default     = "200-399"
  type        = string
}

variable "ip_allowlist" {
  description = "The list of CIDR ranges to allow traffic from"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "http_enabled" {
  description = "A boolean which triggers adding or removing the HTTP listener"
  type        = bool
  default     = true
}

variable "ssl_certificate_enabled" {
  description = "A boolean which triggers adding or removing the HTTPS listener"
  type        = bool
  default     = false
}

variable "ssl_certificate_arn" {
  description = "The ARN of an Amazon Certificate Manager certificate to bind to the load balancer"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "The SSL Policy to use (https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html)"
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
  type        = string
}

variable "tags" {
  description = "The tags to append to this resource"
  default     = {}
  type        = map(string)
}
