# == Class profile::analytics::refinery::job::test::camus
# Uses camus::job to set up cron jobs to
# import data from Kafka into the Hadoop testing cluster.
#
# == Parameters
# [*kafka_cluster_name*]
#   Name of the Kafka cluster in the kafka_clusters hash that will be used
#   to look up brokers from which Camus will import data.
#   Default: 'jumbo'
#
# [*monitoring_enabled*]
#   Enable monitoring for Camus data imported.
#
class profile::analytics::refinery::job::test::camus(
    $kafka_cluster_name = lookup('profile::analytics::refinery::job::camus::kafka_cluster_name', { 'default_value' => 'jumbo' }),
    $monitoring_enabled = lookup('profile::analytics::refinery::job::camus::monitoring_enabled', { 'default_value' => false }),
    $use_kerberos       = lookup('profile::analytics::refinery::job::camus::use_kerberos', { 'default_value' => false }),
) {
    require ::profile::hadoop::common
    require ::profile::analytics::refinery

    $kafka_config  = kafka_config($kafka_cluster_name)
    $kafka_brokers = suffix($kafka_config['brokers']['array'], ':9092')

    $kafka_brokers_jumbo     = suffix($kafka_config['brokers']['array'], ':9092')

    $env = "export PYTHONPATH=\${PYTHONPATH}:${profile::analytics::refinery::path}/python"
    $systemd_env = {
        'PYTHONPATH' => "\${PYTHONPATH}:${profile::analytics::refinery::path}/python",
    }

    $check_email_target = $monitoring_enabled ? {
        true  => 'ltoscano@wikimedia.org',
        false => undef,
    }

    # Make all uses of camus::job set default kafka_brokers and camus_jar.
    # If you build a new camus or refinery, and you want to use it, you'll
    # need to change these.  You can also override these defaults
    # for a particular camus::job instance by setting the parameter on
    # the camus::job declaration.
    Camus::Job {
        script              => "${profile::analytics::refinery::path}/bin/camus",
        kafka_brokers       => $kafka_brokers,
        camus_jar           => "${profile::analytics::refinery::path}/artifacts/org/wikimedia/analytics/camus-wmf/camus-wmf-0.1.0-wmf9.jar",
        check_jar           => "${profile::analytics::refinery::path}/artifacts/org/wikimedia/analytics/refinery/refinery-camus-0.0.90.jar",
        # Email reports if CamusPartitionChecker finds errors.
        check_email_target  => $check_email_target,
        environment         => $systemd_env,
        template_variables  => {
            'hadoop_cluster_name' => $::profile::hadoop::common::cluster_name
        },
        use_kerberos        => $use_kerberos,
    }


    # Import webrequest_* topics into /wmf/data/raw/webrequest
    # every 10 minutes, check runs and flag fully imported hours.
    camus::job { 'webrequest_test':
        check                 => $monitoring_enabled,
        kafka_brokers         => $kafka_brokers_jumbo,
        check_topic_whitelist => 'webrequest_test_text',
        interval              => '*-*-* *:00/10:00',
    }

    # Import eventlogging_NavigationTiming topic into /wmf/data/raw/eventlogging
    # once every hour.
    camus::job { 'eventlogging_test':
        kafka_brokers         => $kafka_brokers_jumbo,
        check                 => true,
        # Don't need to write _IMPORTED flags for EventLogging data
        check_dry_run         => true,
        # Only check these topic, since they should have data every hour.
        check_topic_whitelist => 'eventlogging_NavigationTiming',
        interval              => '*-*-* *:05:00',
    }
}
