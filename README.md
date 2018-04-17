
This is a basic sample of using *awspec* to test terraform.

Run `./init.sh` to install dependencies and terraform init.
Terraform relies on your 'default' aws cli profile.

Run `terraform apply` to create AWS resources.

Run `cp spec/secrets.yml.sample spec/secrets.yml` and edit 'spec/secrets.yml' to include your AWS access key.

Run `rake` to run tests.

Open 'spec/example_spec.rb' to see test source code.
