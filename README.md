[![Release][release-image]][release] [![CI][ci-image]][ci] [![License][license-image]][license] [![Registry][registry-image]][registry]

# terraform-aws-alb

A Terraform module for deploying a simple Application Load Balancer which includes a pre-configured target group which can be used directly with an EC2 auto-scaling group for assigning workers on the configured port.

Listeners are also configured automatically on port 80 & 443 (optionally if a certificate is supplied).  For TLS traffic we are defaulting to TLS 1.2.

## Usage

At a minimum the load balancer module needs to be given a name, VPC and subnet IDs along with the path that health-checks will occur at.  By default only HTTP is supported until a valid ACM certificate is supplied to the module at which point the HTTPS listener should be activated and ready for use.

```hcl
module "collector_lb" {
  source = "snowplow-devops/alb/aws"

  name              = "collector-lb"
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  health_check_path = "/health"
}
```

### Adding a custom certificate

To add a certificate to the load balancer and therefore enable the TLS endpoint you will need to populate two extra variables:

```hcl
module "collector_lb" {
  source = "snowplow-devops/alb/aws"

  name              = "collector-lb"
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  health_check_path = "/health"

  ssl_certificate_arn     = "your-acm-arn-string-here"
  ssl_certificate_enabled = true
}
```

_Note_: `ssl_certificate_enabled` is required to allow for the case where you are creating the ACM certificate in-line with the ALB module as Terraform will not be able to figure out the "count" attribute correctly at plan time.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.45.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.lb_listener_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.lb_listener_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.lb_tg_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.lb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.lb_sg_ingress_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.lb_sg_ingress_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | The path to bind for health checks | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | A name which will be pre-pended to the resources created | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnets to deploy the load balancer across | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to deploy the load balancer within | `string` | n/a | yes |
| <a name="input_egress_port"></a> [egress\_port](#input\_egress\_port) | The port that the downstream webserver exposes over HTTP | `number` | `8080` | no |
| <a name="input_ip_allowlist"></a> [ip\_allowlist](#input\_ip\_allowlist) | The list of CIDR ranges to allow traffic from | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_matcher"></a> [matcher](#input\_matcher) | The response codes expected for health checks | `string` | `"200-399"` | no |
| <a name="input_ssl_certificate_arn"></a> [ssl\_certificate\_arn](#input\_ssl\_certificate\_arn) | The ARN of an Amazon Certificate Manager certificate to bind to the load balancer | `string` | `""` | no |
| <a name="input_ssl_certificate_enabled"></a> [ssl\_certificate\_enabled](#input\_ssl\_certificate\_enabled) | A boolean which triggers adding or removing the HTTPS listener | `bool` | `false` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | The SSL Policy to use (https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html) | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to append to this resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the ALB |
| <a name="output_arn_suffix"></a> [arn\_suffix](#output\_arn\_suffix) | ARN Suffix of the ALB |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS Name of the ALB |
| <a name="output_id"></a> [id](#output\_id) | ID of the ALB |
| <a name="output_listener_http_arn"></a> [listener\_http\_arn](#output\_listener\_http\_arn) | ARN of the HTTP listener |
| <a name="output_listener_https_arn"></a> [listener\_https\_arn](#output\_listener\_https\_arn) | ARN of the HTTPS listener (Note: optional depending on if a certificate is supplied) |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | ID of the security group attached to the load balancer |
| <a name="output_tg_arn"></a> [tg\_arn](#output\_tg\_arn) | ARN of the target group which is attached to the load balancer |
| <a name="output_tg_arn_suffix"></a> [tg\_arn\_suffix](#output\_tg\_arn\_suffix) | ARN suffix of the target group which is attached to the load balancer |
| <a name="output_tg_egress_port"></a> [tg\_egress\_port](#output\_tg\_egress\_port) | Port that the target group is bound to send data over |
| <a name="output_tg_id"></a> [tg\_id](#output\_tg\_id) | ID of the target group which is attached to the load balancer |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Zone ID of the ALB |

# Copyright and license

The Terraform AWS ALB project is Copyright 2021-2022 Snowplow Analytics Ltd.

Licensed under the [Apache License, Version 2.0][license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[release]: https://github.com/snowplow-devops/terraform-aws-alb/releases/latest
[release-image]: https://img.shields.io/github/v/release/snowplow-devops/terraform-aws-alb

[ci]: https://github.com/snowplow-devops/terraform-aws-alb/actions?query=workflow%3Aci
[ci-image]: https://github.com/snowplow-devops/terraform-aws-alb/workflows/ci/badge.svg

[license]: https://www.apache.org/licenses/LICENSE-2.0
[license-image]: https://img.shields.io/badge/license-Apache--2-blue.svg?style=flat

[registry]: https://registry.terraform.io/modules/snowplow-devops/alb/aws/latest
[registry-image]: https://img.shields.io/static/v1?label=Terraform&message=Registry&color=7B42BC&logo=terraform
