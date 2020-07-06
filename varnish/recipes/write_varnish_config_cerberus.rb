template "/etc/varnish/backends.vcl" do
  mode '0755'
  owner 'root'
  # group 
  source "backends_cerberus.vcl.erb"
  variables(:servers => search(:node, "layers:public"), :hp_servers => search(:node, 'layers:high_performance_private'))
end

template "/etc/varnish/custom.vcl" do
  mode '0755'
  owner 'root'
  # group deploy[:group]
  source "custom_cerberus.vcl.erb"
  # variables(:deploy => deploy, :application => application)
end

template "/etc/varnish/default.vcl" do
  mode '0755'
  owner 'root'
  # group deploy[:group]
  source "default.vcl.erb"
  # variables(:deploy => deploy, :application => application)
end

template "/etc/varnish/error_page.vcl" do
  mode '0755'
  owner 'root'
  # group deploy[:group]
  source "error_page.vcl.erb"
  # variables(:deploy => deploy, :application => application)
end