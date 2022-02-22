Puppet::Type.newtype(:libvirtd_config) do
  ensurable

  newparam(:name, :namevar => true) do
    desc 'setting name to manage from libvirtd.conf'
    newvalues(/\S+/)
  end

  newparam(:quote, :boolean => true) do
    desc 'Whether to quote the value.'
    newvalues(:true, :false)
    defaultto false
  end

  newproperty(:value) do
    desc 'The value of the setting to define'
    munge do |value|
      value = value.to_s.strip
      value
    end
  end
end
