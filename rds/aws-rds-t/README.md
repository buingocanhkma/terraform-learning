RDS Module
==========

Terraform module to deploy RDS cluster

Required Variables
------------------

- **availability_zone**: available zone
- **aws_region**: AWS region
- **license_model** : Required for Oracle

Optional Variables
------------------

- **allow_major_version_upgrade**: Defaults true
- **auto_minor_version_upgrade**: Defaults true


Outputs
-------

- instance_id
- instance_address
- rds_dns

Dependencies
------------

None

To Do
-----

License
-------

BSD
MIT

Author Information
------------------
