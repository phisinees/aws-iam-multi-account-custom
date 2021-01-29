locals {
  master_account_id  = "207606013102"
  staging_account_id = "370009776558"
  pro-production     = "680493040616"
  production         = "845342143974"
  training           = "842779164587"

  global_tags = {
    Department  = "technology"
    Team        = "platform"
    Schedule    = "na"
    Tier        = "backend"
    Environment = "global"
    Stage       = "global"
  }
}
