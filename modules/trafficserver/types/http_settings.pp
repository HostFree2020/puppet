# Trafficserver::HTTP_settings wraps HTTP settings
#
# [*accept_no_activity_timeout*]
#   The timeout interval in seconds before Traffic Server closes a connection that has no activity.
#
# [*connect_attempts_timeout*]
#   The timeout value (in seconds) for time to set up a connection to the origin.
#   If parent rules are provided, this setting also sets proxy.config.http.parent_proxy.connect_attempts_timeout
#
# [*keep_alive_no_activity_timeout_in*]
#   Specifies how long Traffic Server keeps connections to clients open for a subsequent request
#   after a transaction ends.
#
# [*keep_alive_no_activity_timeout_out*]
#   Specifies how long Traffic Server keeps connections to origin servers open for a subsequent transfer of data
#   after a transaction ends.
#
# [*post_connect_attempts_timeout*]
#   The timeout value (in seconds) for an origin server connection when the client request is a POST or PUT request.
#
# [*transaction_no_activity_timeout_in*]
#   Specifies how long Traffic Server keeps connections to clients open if a transaction stalls.
#
# [*transaction_no_activity_timeout_out*]
#   Specifies how long Traffic Server keeps connections to origin servers open if the transaction stalls.
#
# [*send_100_continue_response*]
#   If enabled, Traffic Server will reply with a "100 continue" iff the UA provides the "Expect: 100-continue" header
#
# [*max_post_size*]
#   Any positive value will limit the size of post bodies. If a request is received with a post body larger
#   than this limit the response will be terminated with 413 - Request Entity Too Large
#
# [*keep_alive_enabled_out*]
#   Enables (1) or disables (0) keep alive on connections with origin servers for GET/HEAD requests
# [*keep_alive_post_out*]
#   Enables (1) or disables (0) keep alive on connections with origin servers for POST/PUT requests
type Trafficserver::HTTP_settings = Struct[{
    'accept_no_activity_timeout'          => Integer[0],
    'connect_attempts_timeout'            => Integer[0],
    'keep_alive_no_activity_timeout_in'   => Integer[0],
    'keep_alive_no_activity_timeout_out'  => Integer[0],
    'post_connect_attempts_timeout'       => Integer[0],
    'transaction_no_activity_timeout_in'  => Integer[0],
    'transaction_no_activity_timeout_out' => Integer[0],
    'send_100_continue_response'          => Integer[0, 1],
    'max_post_size'                       => Integer[0],
    'keep_alive_enabled_out'              => Integer[0, 1],
    'keep_alive_post_out'                 => Integer[0, 1],
}]
