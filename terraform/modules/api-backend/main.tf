terraform {
  required_providers {
    fly = {
      source = "fly-apps/fly"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

resource "fly_app" "app" {
  org  = var.organization
  name = var.app_name
}

resource "fly_ip" "ip" {
  app  = fly_app.app.name
  type = "v4"
}

resource "fly_cert" "cert" {
  app      = fly_app.app.name
  hostname = var.domain_name
}

# Postgres
resource "fly_volume" "db_data" {
  name   = "data"
  app    = fly_app.app.name
  size   = 1
  region = var.region
}

resource "fly_machine" "postgres" {
  app      = fly_app.app.name
  region   = var.region
  name     = "${var.app_name}-postgres"
  cputype  = "shared"
  cpus     = 1
  memorymb = 256
  image    = "registry-1.docker.io/postgres:15-alpine"
  services = []
  mounts   = [
    {
      volume : "${fly_volume.db_data.id}"
      path : "/var/lib/postgresql/data"
      size_gb : fly_volume.db_data.size
    }
  ]
  env = {
    PGDATA : "/var/lib/postgresql/data/pgdata"
    POSTGRES_PASSWORD : var.postgres_password
    TZ : var.timezone
  }
}

# API backend
resource "fly_machine" "api" {
  app      = fly_app.app.name
  region   = var.region
  name     = var.app_name
  cputype  = "shared"
  cpus     = 1
  memorymb = 256
  image    = "registry.fly.io/skladis-api"
  services = [
    {
      ports = [
        {
          port     = 443
          handlers = ["tls", "http"]
        }
      ]
      protocol : "tcp",
      internal_port : 3009
    }
  ]
  env = {
    PGHOST : fly_machine.postgres.privateip
    RAILS_MASTER_KEY : var.rails_master_key
    POSTGRES_PASSWORD : var.app_postgres_password
    SMTP_USERNAME : var.smtp_username
    SMTP_PASSWORD : var.smtp_password
    S3_ACCESS_KEY : var.s3_access_key
    S3_SECRET_KEY : var.s3_secret_key
    S3_REGION : var.s3_region
    S3_BUCKET : var.s3_bucket
    TIMEZONE : var.timezone
    S3_SIGNING_KEY_PAIR_ID : var.s3_signing_key_pair_id
    S3_SIGNING_PRIVATE_KEY : var.s3_signing_key_pair_private_key
    ROLLBAR_ACCESS_TOKEN : var.rollbar_access_token
  }
}

data "cloudflare_zones" "domain" {
  filter {
    name = var.zone_name
  }
}

resource "cloudflare_record" "verification_dns" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = fly_cert.cert.dnsvalidationhostname
  value   = fly_cert.cert.dnsvalidationtarget
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "domain" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = var.domain_name
  value   = fly_ip.ip.address
  type    = "A"
  proxied = true
}