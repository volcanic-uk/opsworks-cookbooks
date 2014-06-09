nodes = search(:node, "name:*")
nodes.each {|n| Chef::Log.info "====> #{n.attributes("layers")}"}
app_servers = nodes.select {|n| n["layers"]["rails-app"] rescue nil }

template '/home/deploy/theme_sync.sh' do
  source "theme_sync.sh.erb"
  owner "deploy"
  mode "0777"
  variables(:nodes => app_servers)
end
