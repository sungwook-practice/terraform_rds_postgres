variable "vpc_cidr" {
  description = "vpc_cidr"
  type        = string
}

variable "public-subnets" {
  description = "public subnet"
  type = map(object({
    az   = string
    cidr = string
    tags = map(string)
  }))
}

variable "rds_postgres_password" {
  description = "rds postgres 비밀번호"
  type        = string
}

variable "rds_postgres_version" {
  description = "rds posrgres 버전"
  type        = string
}