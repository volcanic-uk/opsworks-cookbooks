execute "download font" do
  command 'wget -O /usr/share/font/zawgyi.ttf https://s3.amazonaws.com/oliver-dev/fonts/zawgyi.ttf'
  user "root"
  not_if File.exists?('/usr/share/font/zawgyi.ttf')
end

execute "refresh font cache" do
  command 'fc-cache -f -v'
  user "root"
end