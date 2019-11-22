#
# Copyright 2019 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Define: glance::backend::multistore::rbd
#
# configures the storage backend for glance
# as a rbd instance
#
# === Parameters:
#
# [*rbd_store_user*]
#   Optional. Default: $::os_service_default.
#
# [*rbd_store_pool*]
#   Optional. Default: $::os_service_default.
#
# [*rbd_store_ceph_conf*]
#   Optional. Default: $::os_service_default.
#
# [*rbd_store_chunk_size*]
#   Optional. Default: $::os_service_default.
#
# [*manage_packages*]
#   Optional. Whether we should manage the packages.
#   Defaults to true,
#
# [*package_ensure*]
#   Optional. Desired ensure state of packages.
#   accepts latest or specific versions.
#   Defaults to present.
#
# [*rados_connect_timeout*]
#   Optinal. Timeout value (in seconds) used when connecting
#   to ceph cluster. If value <= 0, no timeout is set and
#   default librados value is used.
#   Default: $::os_service_default.
#
# [*store_description*]
#   (optional) Provides constructive information about the store backend to
#   end users.
#   Defaults to $::os_service_default.
#
define glance::backend::multistore::rbd(
  $rbd_store_user        = $::os_service_default,
  $rbd_store_ceph_conf   = $::os_service_default,
  $rbd_store_pool        = $::os_service_default,
  $rbd_store_chunk_size  = $::os_service_default,
  $manage_packages       = true,
  $package_ensure        = 'present',
  $rados_connect_timeout = $::os_service_default,
  $store_description     = $::os_service_default,
) {

  include ::glance::deps
  include ::glance::params

  glance_api_config {
    "${name}/rbd_store_ceph_conf":    value => $rbd_store_ceph_conf;
    "${name}/rbd_store_user":         value => $rbd_store_user;
    "${name}/rbd_store_pool":         value => $rbd_store_pool;
    "${name}/rbd_store_chunk_size":   value => $rbd_store_chunk_size;
    "${name}/rados_connect_timeout":  value => $rados_connect_timeout;
    "${name}/store_description":      value => $store_description;
  }

  if $manage_packages and !defined(Package["${::glance::params::pyceph_package_name}"]) {
    ensure_resource('package', 'python-ceph', {
      ensure => $package_ensure,
      name   => $::glance::params::pyceph_package_name,
      tag    => 'glance-support-package',
    })
  }

  create_resources('glance_api_config', {})
}
