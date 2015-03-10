use File::Spec;
use Test::Nginx::Socket;

repeat_each(5);

plan tests => repeat_each() * 2 * blocks();

our $config_location = <<'_EOC_';
    location = /extended_status {
	  	extended_status on;
	}
	location = /disabled_extended_status {
		extended_status off;
	}
_EOC_

master_on();

run_tests();

__DATA__

=== TEST 1: module is enabled
--- log_level: debug
--- config eval: $::config_location
--- request
    GET /extended_status
--- response_body_like: <title>Nginx Status</title>
--- timeout: 10



=== TEST 2: module is enabled (second check)
--- log_level: debug
--- config eval: $::config_location
--- request
    GET /extended_status
--- response_body_like: <h1>Nginx Server Status for [^<]*</h1>
--- timeout: 10



=== TEST 3: detects server version
--- log_level: debug
--- config eval: $::config_location
--- request
    GET /extended_status
--- response_body_like: Server Version: Nginx/[0-9]+\.[0-9]+\.[0-9]+
--- timeout: 10



=== TEST 4: active connections count
--- log_level: debug
--- config eval: $::config_location
--- request
    GET /extended_status
--- response_body_like: Active connections: [0-9]
--- timeout: 10



=== TEST 5: reading writing waiting stats
--- log_level: debug
--- config eval: $::config_location
--- request
    GET /extended_status
--- response_body_like: <th>Reading:</th><td> 0 </td><th>Writing:</th><td> 1 </td><th>Waiting:</th><td> 0 </td>
--- timeout: 10
