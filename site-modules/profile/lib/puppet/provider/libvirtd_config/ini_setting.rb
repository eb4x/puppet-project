Puppet::Type.type(:libvirtd_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  def exists?
    if resource[:quote]
      unless resource[:value].starts_with?('"')
        resource[:value] = '"' + resource[:value] + '"'
      end
    end
    super
  end

  def section
    ''
  end

  def setting
    resource[:name]
  end

  # hard code the file path (this allows purging)
  def self.file_path
    '/etc/libvirt/libvirtd.conf'
  end
end
