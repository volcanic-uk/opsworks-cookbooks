extra_ips = []
extra_ips = node[:varnish][:server_ips].map{|e| {:private_ip => e} } if !node[:varnish][:server_ips].nil?

template "/etc/varnish/backends.vcl" do
  mode '0755'
  owner 'root'
  # group 
  source "backends.vcl.erb"
  # variables(:servers => search(:node, "layers:public"), :hp_servers => search(:node, 'layers:high_performance_private'))
  variables(:servers => search(:node, "layers:public"), :hp_servers => (search(:node, 'layers:high_performance_private').to_a + extra_ips))
end

template "/etc/varnish/custom.vcl" do
  mode '0755'
  owner 'root'
  # group deploy[:group]
  source "custom.vcl.erb"
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