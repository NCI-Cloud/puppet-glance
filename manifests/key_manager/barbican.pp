# == Class: glance::key_manager::barbican
#
# Setup and configure Barbican Key Manager options
#
# === Parameters
#
# [*barbican_endpoint*]
#   (Optional) Use this endpoint to connect to Barbican.
#   Defaults to $::os_service_default
#
# [*barbican_api_version*]
#   (Optional) Version of the Barbican API.
#   Defaults to $::os_service_default
#
# [*auth_endpoint*]
#   (Optional) Use this endpoint to connect to Keystone.
#   Defaults to $::os_service_default
#
# [*retry_delay*]
#   (Optional) Number of seconds to wait before retrying poll for key creation
#   completion.
#   Defaults to $::os_service_default
#
# [*number_of_retries*]
#   (Optional) Number of times to retry poll fo key creation completion.
#   Defaults to $::os_service_default
#
# [*barbican_endpoint_type*]
#   (Optional) Specifies the type of endpoint.
#   Defaults to $::os_service_default
#
# [*barbican_region_name*]
#   (Optional) Specifies the region of the chosen endpoint.
#   Defaults to $::os_service_default
#
# [*send_service_user_token*]
#   (Optional) The service uses service token feature when this is set as true.
#   Defaults to $::os_service_default
#
class glance::key_manager::barbican (
  $barbican_endpoint       = $::os_service_default,
  $barbican_api_version    = $::os_service_default,
  $auth_endpoint           = $::os_service_default,
  $retry_delay             = $::os_service_default,
  $number_of_retries       = $::os_service_default,
  $barbican_endpoint_type  = $::os_service_default,
  $barbican_region_name    = $::os_service_default,
  $send_service_user_token = $::os_service_default,
) {

  include glance::deps

  $barbican_endpoint_real = pick($glance::api::keymgr_encryption_api_url, $barbican_endpoint)
  $auth_endpoint_real = pick($glance::api::keymgr_encryption_auth_url, $auth_endpoint)

  oslo::key_manager::barbican { 'glance_api_config':
    barbican_endpoint       => $barbican_endpoint_real,
    barbican_api_version    => $barbican_api_version,
    auth_endpoint           => $auth_endpoint_real,
    retry_delay             => $retry_delay,
    number_of_retries       => $number_of_retries,
    barbican_endpoint_type  => $barbican_endpoint_type,
    barbican_region_name    => $barbican_region_name,
    send_service_user_token => $send_service_user_token,
  }
}
