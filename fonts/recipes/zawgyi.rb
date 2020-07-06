apt_package 'fontconfig'

directory '/usr/share/fonts' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute "download font" do
  command 'wget https://s3.amazonaws.com/oliver-dev/fonts/zawgyi.ttf'
  user "root"
  cwd '/usr/share/fonts/'
  not_if { ::File.exists?('/usr/share/fonts/zawgyi.ttf') }
end

execute "refresh font cache" do
  command 'fc-cache -f -v'
  user "root"
end