
locals {
    ecosystem_name = "snapshot"
}


module postgres_db {

    source = "./.."

    in_security_group_id = module.security-group.out_security_group_id
    in_db_subnet_ids     = module.vpc-network.out_private_subnet_ids
    in_snapshot_name     = var.in_snapshot_name

    in_database_name = "${ local.ecosystem_name }${ module.resource-tags.out_tag_timestamp }"

    in_ecosystem_name  = local.ecosystem_name
    in_tag_timestamp   = module.resource-tags.out_tag_timestamp
    in_tag_description = module.resource-tags.out_tag_descrbiption
}


module vpc-network {

    source                 = "github.com/devops4me/terraform-aws-vpc-network"
    in_vpc_cidr            = "10.79.0.0/16"
    in_num_public_subnets  = 3
    in_num_private_subnets = 3

    in_ecosystem_name  = local.ecosystem_name
    in_tag_timestamp   = module.resource-tags.out_tag_timestamp
    in_tag_description = module.resource-tags.out_tag_description
}


module security-group {

    source         = "github.com/devops4me/terraform-aws-security-group"
    in_ingress     = [ "ssh", "https",  ]
    in_vpc_id      = module.vpc-network.out_vpc_id

    in_ecosystem_name  = local.ecosystem_name
    in_tag_timestamp   = module.resource-tags.out_tag_timestamp
    in_tag_description = module.resource-tags.out_tag_description
}


module resource-tags {

    source = "github.com/devops4me/terraform-aws-resource-tags"

}
