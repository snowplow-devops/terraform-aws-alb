## Collector Load Balancer

This example shows how to create a default load balancer for a Snowplow Collector.  Here the only thing that we really need to configure is the health check path to point to `/health` which is the path this service exposes.

```hcl
module "collector_lb" {
  source = "snowplow-devops/alb/aws"

  name              = "collector-lb"
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  health_check_path = "/health"
}
```
