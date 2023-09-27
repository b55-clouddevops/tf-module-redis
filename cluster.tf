# Creates Elastic Cache Cluster
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${var.ENV}-redis"
  engine               = "redis"
  node_type            = "cache.t3.small"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.default.name
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.allows_redis.id]
  engine_version       = "6.x"
  port                 = 6379
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "roboshop-${var.ENV}-redis-pg"
  family = "redis6.x"
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "roboshop-${var.ENV}-redis-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS 
  tags = {
    Name = "roboshop-${var.ENV}-redis-subnet-group"
  }
}