# @summary this function parses a Hash of Network::Abuse_net objects and
#          returns a list of networks appropriate for the context
# @param abuse_nets a list of abuse networks with meta data indicating
#                   where they should be used.
#                   Default: lookup('abuse_networks')
# @param context either ferm or varnish to indicate where the list will be used
function network::parse_abuse_nets(
    Network::Context                    $context,
    Hash[String[1], Network::Abuse_net] $abuse_nets = lookup('abuse_networks'),
) >> Hash[String[1], Array[Stdlib::IP::Address]] {
    $abuse_nets.reduce({}) |$memo, $abuse_net| {
        if $context in $abuse_net[1]['context'] {
            $memo + { $abuse_net[0] => $abuse_net[1]['networks'] }
        } else {
            $memo
        }
    }
}
