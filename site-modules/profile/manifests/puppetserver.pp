class profile::puppetserver(
  Hash[String, String] $r10k_sources = {},
) {

  ## https://stackoverflow.com/questions/44668877/append-a-hash-to-a-series-of-nested-hashes-in-puppet4
  #$sources = $r10k_sources.reduce({}) |$memo, $src| {
  #  $memo + {
  #    $src[0] => {
  #      'remote' => $r10k_sources[$src[0]],
  #      'basedir' => "${::settings::codedir}/environments",
  #    }
  #  }
  #}

  # https://puppet.com/docs/puppet/6/function.html#conversion-to-hash-and-struct
  # An Array with an even number of entries is interpreted as [key1, val1, key2, val2, ...]
  $sources = Hash( $r10k_sources.map |$name, $url| {
    [ $name, { 'remote' => $url, 'basedir' => "${::settings::codedir}/environments" } ]
  } )

  class { '::r10k':
    sources => $sources
  }
}
