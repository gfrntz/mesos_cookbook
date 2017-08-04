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

template 'marathon-master' do
  path '/etc/marathon/conf/master'
  source 'marathon.master.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :mesos_masters => node['mesos']['master']['flags']['zk']
  )
  notifies :restart, 'service[marathon]'
end

template 'marathon-zk' do
  path '/etc/marathon/conf/zk'
  source 'marathon.master.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :mesos_masters => node['mesos']['master']['flags']['zk'].gsub(/'mesos'$/, 'marathon')
  )
  notifies :restart, 'service[marathon]'
end

service 'marathon' do
  action [ :enable, :start ]
end
