$verified_certname = $::trusted['certname']
$fqdn_array        = split($::verified_certname, '\.')
$short_name        = $::fqdn_array[0]
$short_name_array  = split($::short_name, '-')

notify { "$location":
}

if $short_name_array.size == 3 {
#  $location = $short_name_array[0]
  $role     = $short_name_array[1]

  include "role::${role}"
} elsif $short_name == "foreman" {
  include role::admin
}

node default { }
