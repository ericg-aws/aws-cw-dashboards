resource "aws_cloudwatch_metric_alarm" "jumphost_data01_throughput" {
    alarm_name                = "instance-${local.name_prefix}_jumphost_data01_throughput"
    comparison_operator       = "GreaterThanOrEqualToThreshold"
    evaluation_periods        = "2"
    threshold                 = "112"
    alarm_description         = "Volume Throughput has exceeded 90%"
    insufficient_data_actions = []

    metric_query {
    id          = "e1"
    expression  = "(m1+m2)/PERIOD(m1)/1024/1024"
    label       = "Throughput MB/sec"
    return_data = "true"
    }

    metric_query {
    id = "m1"

    metric {
        metric_name = "VolumeWriteBytes"
        namespace   = "AWS/EBS"
        period      = "60"
        stat        = "Average"
        unit        = "Bytes"

        dimensions = {
            VolumeId = "${data.aws_ebs_volume.ebs01.id}"
        }
    }
    }

    metric_query {
    id = "m2"

    metric {
        metric_name = "VolumeReadBytes"
        namespace   = "AWS/EBS"
        period      = "60"
        stat        = "Average"
        unit        = "Bytes"

        dimensions = {
            VolumeId = "${data.aws_ebs_volume.ebs01.id}"
        }
    }
    }
}