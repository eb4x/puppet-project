$verified_certname = $::trusted['certname']
$fqdn_array        = split($::verified_certname, '\.')
$short_name        = $::fqdn_array[0]
$short_name_array  = split($::short_name, '-')

$location          = $::short_name_array[0]
$role              = $::short_name_array[1]

# dumb test
if size($short_name_array) == 3 {
  include role::$role
} else if $short_name == "foreman" {
  include role::admin
}

#lookup('classes', {merge => unique}).include
