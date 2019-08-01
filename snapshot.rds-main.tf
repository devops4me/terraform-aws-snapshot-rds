
/*
 | --
 | -- Create a simple AWS PostgreSQL RDS database from either the
 | -- last available snapshot, or via the specified snapshot identifier
 | -- of another database.
 | --
 | -- This module effectively clones a database at the point at which
 | -- the snapshot in question is taken.
 | --
*/
resource aws_db_instance postgres {

    snapshot_identifier = data.aws_db_snapshot.parent.id

    identifier = "${ var.in_database_name }-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"

    name     = var.in_database_name
    username = "readwrite"
    password = random_string.password.result
    port     = 5432

    engine            = "postgres"
    instance_class    = "db.t2.large"
    multi_az          = true

    storage_encrypted      = false
    vpc_security_group_ids = [ var.in_security_group_id ]
    db_subnet_group_name   = aws_db_subnet_group.me.id
    skip_final_snapshot    = true

}



data aws_db_snapshot parent {
    most_recent = true
    db_instance_identifier = var.in_id_of_db_to_clone
}


/*
 | --
 | -- This multi-availability zone postgres database will be created within
 | -- the (usually) private subnets denoted by in_db_subnet_ids variable.
 | --
*/
resource aws_db_subnet_group me {

    name_prefix = "db-${ var.in_ecosystem_name }"
    description = "RDS postgres subnet group for the ${ var.in_ecosystem_name } database."
    subnet_ids  = var.in_db_subnet_ids

}


/*
 | --
 | -- The Terraform generated database password will contain
 | -- 16 alphanumeric characters and no specials. Note that a fixed
 | -- password length greatly reduces the (brute force) search space.
 | --
*/
resource random_string password {
    length  = 16
    upper   = true
    lower   = true
    number  = true
    special = false
}
