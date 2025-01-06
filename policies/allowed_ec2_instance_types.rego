package terraform

import rego.v1

allowed_ec2_instances := ["t3.micro", "t4g.micro"]

deny contains msg if {
	some resource in input.resource_changes
	resource.type == "aws_instance"
	ec2_instance_type := resource.change.after.instance_type
	not ec2_instance_type in allowed_ec2_instances
	msg := sprintf(
		"instance type for '%s' is '%s', but must one of '%s'.",
		[resource.address, ec2_instance_type, allowed_ec2_instances],
	)
}