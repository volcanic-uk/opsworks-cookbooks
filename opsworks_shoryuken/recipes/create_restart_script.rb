node[:deploy].each do |application, deploy|
  template "/srv/www/#{application}/shared/scripts/shoryuken-restart.sh" do
    source "shoryuken-restart.sh.erb"
    owner "deploy"
    group "www-data"
    mode 0755
    variables({
      application: application
    })
  end
  
  cron "shoryuken-workers-#{application}-restart" do
    minute  '*/5'
    command "/srv/www/#{application}/shared/scripts/shoryuken-restart.sh >/dev/null 2>&1"
  end
end
