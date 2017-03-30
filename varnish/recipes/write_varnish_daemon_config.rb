template "/etc/default/varnish" do
  mode '0755'
  owner 'root'
  # group deploy[:group]
  source "varnish.erb"
  # variables(:deploy => deploy, :application => application)
end

service "varnish" do
  action :restart
end
