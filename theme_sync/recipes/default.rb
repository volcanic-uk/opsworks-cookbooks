# ======================================
# = Allow Devbox to push theme changes =
# ======================================
template '/home/deploy/.ssh/authorized_keys' do
  source "authorized_keys.erb"
  owner "deploy"
  mode "0600"
end

# ==============================================
# = Allow App Server to pull themes are deploy =
# ==============================================
template '/home/deploy/.ssh/id_rsa' do
  source "id_rsa.erb"
  owner "deploy"
  mode "0600"
end

# ===================
# = Pull Themes Now =
# ===================
execute "rsync themes and assets" do
  command "rsync -avz -e ssh deploy@#{node[:theme_sync][:ip]}:/cloud9/sync /srv/www/oliver/shared"
  user "deploy"
end


# ==========================================================
# = Update Push script so theme deploys to all App Servers =
# ==========================================================

nodes = search(:node, "name:*")
app_servers = nodes.select {|n| n["opsworks"]["layers"]["rails-app"] rescue nil }

template '/home/deploy/precompile_and_rsync.sh' do
  source "precompile_and_rsync.sh.erb"
  owner "deploy"
  mode "0777"
  variables(:nodes => app_servers)
end

# ======================================
# = Copy the push script to the devbox =
# ======================================

execute "copy rsync bash script to dev box" do
  command "scp /home/deploy/precompile_and_rsync.sh deploy@#{node[:theme_sync][:ip]}:/cloud9/precompiled_assets/oliver-precompile/"
  user "deploy"
end
