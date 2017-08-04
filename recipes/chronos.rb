#
# Cookbook Name:: mesos
# Recipe:: chronos
#

if node['mesos']['chronos']['version'].nil?
  package 'chronos'
else
  package 'chronos' do
    version node['mesos']['chronos']['version']
  end
end

directory '/etc/chronos/conf' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

node['mesos']['chronos']['flags'].each do |flag,value|
  template "Generating #{flag} parameter" do
    path "/etc/chronos/conf/#{flag}"
    source 'flag.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :value => value
    )
    notifies :restart, 'service[chronos]'
  end
end

service 'chronos' do
  action [ :enable, :start ]
end
