node[:deploy].each do |application, deploy|
  if deploy['shoryuken']
    shoryuken_config = deploy['shoryuken']
    release_path = ::File.join(deploy[:deploy_to], 'current')
    rails_env = deploy[:rails_env]
    num_workers = shoryuken_config['num_workers'] || 2
    start_command = shoryuken_config['start_command'] || "bundle exec shoryuken -R -C config/shoryuken.yml 2>&1 >> log/shoryuken.log"
    env = deploy['environment_variables'] || {}

    template "setup shoryuken.conf" do
      path "/etc/init/shoryuken-#{application}.conf"
      source "shoryuken.conf.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        app_name: application,
        user: deploy[:user],
        group: deploy[:group],
        release_path: release_path,
        rails_env: rails_env,
        start_command: start_command,
        env: env,
      })
    end

    template "setup shoryuken-workers.conf" do
      path "/etc/init/shoryuken-workers-#{application}.conf"
      source "shoryuken-workers.conf.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        app_name: application,
        num_workers: num_workers,
      })
    end

    service "shoryuken-#{application}" do
      provider Chef::Provider::Service::Upstart
      supports stop: true, start: true, restart: true, status: true
    end

    service "shoryuken-workers-#{application}" do
      provider Chef::Provider::Service::Upstart
      supports stop: true, start: true, restart: true, status: true
    end

    # always restart shoryuken on deploy since we assume the code must need to be reloaded
    bash 'restart_shoryuken' do
      code "echo noop"
      notifies :restart, "service[shoryuken-workers-#{application}]"
    end
  end
end
