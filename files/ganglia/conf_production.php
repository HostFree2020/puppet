<?php

#
# If you installed gmetad in a directory other than the default
# make sure you change it here.
#

# Where gmetad stores the rrd archives.
$conf['gmetad_root'] = "/mnt/ganglia_tmp";
$conf['rrds'] = "${conf['gmetad_root']}/rrds.pmtpa";

# If you want to grab data from a different ganglia source specify it here.
# Although, it would be strange to alter the IP since the Round-Robin
# databases need to be local to be read. 
#
$conf['ganglia_ip'] = "127.0.0.1";
$conf['ganglia_port'] = 8654;

#
# Default metric 
#
$conf['default_metric'] = "cpu_report";

?>
