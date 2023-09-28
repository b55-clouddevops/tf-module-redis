# Creates Elastic Cache Cluster
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${var.ENV}-redis"
  engine               = "redis"
  node_type            = var.REDIS_INSTANCE_TYPE
  num_cache_nodes      = var.REDIS_INSTANCE_COUNT
  parameter_group_name = aws_elasticache_parameter_group.default.name
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.allows_redis.id]
  engine_version       = var.REDIS_ENGINE_VERSION
  port                 = var.REDIS_PORT
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