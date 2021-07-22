resource "aws_cloudwatch_dashboard" "cpu" { 
  dashboard_name = "instance-${local.name_prefix}_jumphost"
  dashboard_body = <<EOF
{
    "widgets": [
    {
        "height": 6,
        "width": 12,
        "y": 0,
        "x": 0,
        "type": "metric",
        "properties": {
            "metrics": [
                [ "AWS/EC2", "CPUUtilization", "InstanceId", "${module.ec2_instances.id[0]}" ]
            ],
            "period": 60,
            "stat": "Average",
            "region": "${var.region}",
            "title": "Cpu"
        }
    },
    {
        "height": 6,
        "width": 12,
        "y": 0,
        "x": 12,
        "type": "metric",
        "properties": {
            "metrics": [
                [ "CWAgent", "mem_used_percent", "InstanceId", "${module.ec2_instances.id[0]}", "ImageId", "${var.ec2_analytics_small_ami_id}", "InstanceType", "${var.ec2_analytics_small_instance_type}" ]
            ],
            "period": 300,
            "stat": "Average",
            "region": "${var.region}",
            "title": "Mem",
            "yAxis": {
                "right": {
                    "min": 0,
                    "max": 100,
                    "showUnits": false
                },
                "left": {
                    "label": "Used %",
                    "showUnits": false
                }
            }
        }
    },
    {
        "height": 6,
        "width": 12,
        "y": 12,
        "x": 0,
        "type": "metric",
        "properties": {
            "metrics": [
                [ { "expression": "(m1)/1024/1024/1024/PERIOD(m1)*8", "label": "Network In", "id": "e1", "region": "${var.region}", "stat": "Maximum" } ],
                [ { "expression": "(m2)/1024/1024/1024/PERIOD(m2)*8", "label": "Network Out", "id": "e2", "region": "${var.region}", "stat": "Maximum" } ],
                [ "AWS/EC2", "NetworkIn", "InstanceId", "${module.ec2_instances.id[0]}", { "id": "m1", "visible": false } ],
                [ ".", "NetworkOut", ".", ".", { "id": "m2", "visible": false } ]
            ],
            "view": "timeSeries",
            "stacked": false,
            "region": "${var.region}",
            "stat": "Maximum",
            "period": 60,
            "title": "Network",
            "yAxis": {
                "right": {
                    "min": 0,
                    "max": 10000,
                    "showUnits": false
                },
                "left": {
                    "label": "Bandwidth (Gbps)",
                    "showUnits": false
                }
            },
            "annotations": {
                "horizontal": [
                    {
                        "label": "${var.ec2_analytics_small_instance_type} max bandwidth",
                        "value": 10
                    }
                ]
            }
        }
    },
    {
        "height": 6,
        "width": 12,
        "y": 12,
        "x": 12,
        "type": "metric",
        "properties": {
            "metrics": [
                [ { "expression": "((m1+m2)/1048576)/PERIOD(m1)", "label": "Total", "id": "e1", "region": "${var.region}" } ],
                [ "AWS/EC2", "EBSReadBytes", "InstanceId", "${module.ec2_instances.id[0]}", { "id": "m1", "visible": false } ],
                [ "AWS/EC2", "EBSWriteBytes", "InstanceId", "${module.ec2_instances.id[0]}", { "id": "m2", "visible": false } ]
            ],
            "view": "timeSeries",
            "stacked": false,
            "region": "${var.region}",
            "stat": "Sum",
            "period": 60,
            "title": "Instance Throughput",
            "yAxis": {
                "right": {
                    "min": 0,
                    "max": 1000,
                    "label": "",
                    "showUnits": false
                },
                "left": {
                    "showUnits": false,
                    "label": "MB/sec",
                    "max": 1000
                }
            },
            "annotations": {
                "horizontal": [
                    {
                        "label": "${var.ec2_analytics_small_instance_type} max throughput",
                        "value": 593
                    }
                ]
            }
        }
    },
    {
        "height": 6,
        "width": 12,
        "y": 24,
        "x": 0,
        "type": "metric",
        "properties": {
            "metrics": [
                [ { "expression": "((m1+m2)/PERIOD(m1))", "label": "Total", "id": "e1", "region": "${var.region}" } ],
                [ "AWS/EC2", "EBSReadOps", "InstanceId", "${module.ec2_instances.id[0]}", { "id": "m1", "visible": false } ],
                [ "AWS/EC2", "EBSWriteOps", "InstanceId", "${module.ec2_instances.id[0]}", { "id": "m2", "visible": false } ]
            ],
            "view": "timeSeries",
            "stacked": false,
            "region": "${var.region}",
            "stat": "Sum",
            "period": 60,
            "title": "Instance IOPS",
            "yAxis": {
                "right": {
                    "min": 0,
                    "max": 19000,
                    "label": "",
                    "showUnits": false
                },
                "left": {
                    "showUnits": false,
                    "label": "IOPS",
                    "max": 19000
                }
            },
            "annotations": {
                "horizontal": [
                    {
                        "label": "${var.ec2_analytics_small_instance_type} max IOPS",
                        "value": 18750
                    }
                ]
            }
        }
    },
    {
        "height": 6,
        "width": 12,
        "y": 24,
        "x": 12,
        "type": "metric",
        "properties": {
            "metrics": [
                [ { "expression": "(SUM([m3])/SUM([m1])) * 1000", "label": "OS Vol - Read", "id": "e1", "region": "${var.region}" } ],
                [ { "expression": "(SUM([m4])/SUM([m2])) * 1000", "label": "OS Vol - Write", "id": "e2", "region": "${var.region}" } ],
                [ { "expression": "(SUM([m7])/SUM([m5])) * 1000", "label": "Data01 Vol - Read", "id": "e3", "region": "${var.region}" } ],
                [ { "expression": "(SUM([m8])/SUM([m6])) * 1000", "label": "Data01 Vol - Write", "id": "e4", "region": "${var.region}" } ],
                [ "AWS/EBS", "VolumeReadOps", "VolumeId", "${module.ec2_instances.root_block_device_volume_ids[0][0]}", { "id": "m1", "visible": false } ],
                [ ".", "VolumeWriteOps", ".", ".", { "id": "m2", "visible": false } ],
                [ ".", "VolumeTotalReadTime", ".", ".", { "id": "m3", "visible": false } ],
                [ ".", "VolumeTotalWriteTime", ".", ".", { "id": "m4", "visible": false } ],
                [ "AWS/EBS", "VolumeReadOps", "VolumeId", "${data.aws_ebs_volume.ebs01.id}", { "id": "m5", "visible": false } ],
                [ ".", "VolumeWriteOps", ".", ".", { "id": "m6", "visible": false } ],
                [ ".", "VolumeTotalReadTime", ".", ".", { "id": "m7", "visible": false } ],
                [ ".", "VolumeTotalWriteTime", ".", ".", { "id": "m8", "visible": false } ]
            ],
            "view": "timeSeries",
            "stacked": false,
            "region": "${var.region}",
            "stat": "Average",
            "period": 60,
            "title": "Volume Latency",
            "yAxis": {
                "right": {
                    "min": 0,
                    "max": 3000,
                    "label": "",
                    "showUnits": false
                },
                "left": {
                    "label": "Avg Read Latency (ms)",
                    "showUnits": false
                }
            }
        }
    },
    {
        "height": 6,
        "width": 12,
        "y": 36,
        "x": 0,
        "type": "metric",
        "properties": {
            "metrics": [
                [ { "expression": "(m1+m2)/PERIOD(m1)", "label": "OS Vol", "id": "e1", "region": "${var.region}" } ],
                [ { "expression": "(m3+m4)/PERIOD(m3)", "label": "Data01 Vol", "id": "e2", "region": "${var.region}" } ],
                [ "AWS/EBS", "VolumeReadOps", "VolumeId", "${module.ec2_instances.root_block_device_volume_ids[0][0]}", { "id": "m1", "visible": false } ],
                [ ".", "VolumeWriteOps", ".", ".", { "id": "m2", "visible": false } ],
                [ "AWS/EBS", "VolumeReadOps", "VolumeId", "${data.aws_ebs_volume.ebs01.id}", { "id": "m3", "visible": false } ],
                [ ".", "VolumeWriteOps", ".", ".", { "id": "m4", "visible": false } ]
            ],
            "view": "timeSeries",
            "stacked": false,
            "region": "${var.region}",
            "stat": "Average",
            "period": 60,
            "title": "Volume IOPS",
            "yAxis": {
                "right": {
                    "min": 0,
                    "max": 3200,
                    "label": "",
                    "showUnits": false
                },
                "left": {
                    "label": "IOPS",
                    "showUnits": false,
                    "max": 3200
                }
            },
            "annotations": {
                "horizontal": [
                    {
                        "label": "gp3 baseline IOPS",
                        "value": 3000
                    }
                ]
            }
        }
    },
        {
        "height": 6,
        "width": 12,
        "y": 36,
        "x": 12,
        "type": "metric",
        "properties": {
            "metrics": [
                [ { "expression": "(m1+m2)/PERIOD(m1)/1024/1024", "label": "OS Vol", "id": "e1", "region": "us-east-1" } ],
                [ { "expression": "(m2+m3)/PERIOD(m2)/1024/1024", "label": "Data01 Vol", "id": "e2", "region": "us-east-1" } ],
                [ "AWS/EBS", "VolumeWriteBytes", "VolumeId", "${module.ec2_instances.root_block_device_volume_ids[0][0]}", { "id": "m1", "visible": false } ],
                [ ".", "VolumeReadBytes", ".", ".", { "id": "m2", "visible": false } ],
                [ "AWS/EBS", "VolumeWriteBytes", "VolumeId", "${data.aws_ebs_volume.ebs01.id}", { "id": "m3", "visible": false } ],
                [ ".", "VolumeReadBytes", ".", ".", { "id": "m4", "visible": false } ]
            ],
            "view": "timeSeries",
            "stacked": false,
            "region": "${var.region}",
            "stat": "Average",
            "period": 60,
            "title": "Volume Throughput",
            "yAxis": {
                "right": {
                    "min": 0,
                    "label": "",
                    "showUnits": false
                },
                "left": {
                    "showUnits": false,
                    "label": "MB/sec",
                    "max": 200
                }
            },
            "annotations": {
                "horizontal": [
                    {
                        "label": "gp3 baseline throughput",
                        "value": 125
                    }
                ]
            }
        }
    }
    ]
}
EOF
}