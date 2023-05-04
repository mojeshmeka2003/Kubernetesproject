terraform {
    required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "~> 4.0"
    }
}
backend "s3" {
    bucket="mybucket30625"
    encrypt=true
    key="terraform.tfstate"
    region = "us-east-1"
    }
}
provider "aws" {
    region = "us-east-1"
}
resource "aws_vpc" "mainvpc" {
    cidr_block = "10.1.0.0/16"
}
resource "aws_security_group" "cw_sg_ssh" {
    name = "terraform"
    #Incoming traffic
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #replace it with your ip address
}
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #replace it with your ip address
    }
    #Outgoing traffic
    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "my-machine" {
    count = 3
    # Creates four identical aws ec2 instances
    # All four instances will have the same ami and instance_type
    ami = "ami-03c7d01cf4dedc891"
    instance_type = "t2.micro"
    key_name="hkv"
    security_groups = ["cw-blog-3-sg-using-terraform"]
    tags = {
        # The count.index allows you to launch a resource
        # starting with the distinct index number 0 and corresponding to this
    
        Name = "my-machine-${count.index}"
    }
}
resource "aws_cloudwatch_metric_alarm" "disk_percentage_low" {
    for_each = toset(var.instance)
    alarm_name = "disk_percentage_low"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "LogicalDisk % Free Space"
    namespace = "AWS/EC2"
    period = "60"
    statistic = "Average"
    threshold = "20"
    alarm_description = "This metric monitors ec2 disk utilization"
    actions_enabled = "true"
    #alarm_actions = [aws_sns_topic.disk_alarm.arn]
    insufficient_data_actions = []
    dimensions = {
        InstanceId = "aws_instance.my-machine.my-machine-0.id"
        InstanceType = "t2.micro"
        instance = each.value
    }
}
