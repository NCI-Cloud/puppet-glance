# == Class: glance::policy
#
# Configure the glance policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for glance
#   Example :
#     {
#       'glance-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'glance-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the glance policy.yaml file
#   Defaults to /etc/glance/policy.yaml
#
class glance::policy (
  $policies    = {},
  $policy_path = '/etc/glance/policy.yaml',
) {

  include glance::deps
  include glance::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::glance::params::group,
    file_format => 'yaml',
    require     => Anchor['glance::config::begin'],
    notify      => Anchor['glance::config::end'],
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'glance_api_config': policy_file => $policy_path }

}
