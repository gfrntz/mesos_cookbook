#
# Cookbook Name:: mesos
# Recipe:: marathon
#


if node['mesos']['marathon']['version'].nil?
  package 'marathon'
else
  package 'marathon' do
    version node['mesos']['marathon']['version']
  end
end

directory '/etc/marathon/conf' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

node['mesos']['marathon']['flags'].each do |flag,value|
  template "Generating #{flag} parameter" do
    path "/etc/marathon/conf/#{flag}"
    source 'flag.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :value => value
    )
    notifies :restart, 'service[marathon]'
  end
end


service 'marathon' do
  action [ :enable, :start ]
end
