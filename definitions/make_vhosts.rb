define :make_vhosts, :params => {} do
  suffix = nil
  suffix = '.ssl' if node[:force_ssl]

  vhosts_dir = "%s/vhosts" % [
    params[:cwd]
  ]

  vh = "%s/%s%s" % [
      vhosts_dir,
      node[:project_fqdn],
      suffix
  ]

  directory vhosts_dir do
    action :create
    owner params[:user]
  end

  template vh do
    source "vhost.erb"
    variables(
        :servername         => node[:git_project],
        :domain             => node[:deployment][:domain],
        :listen_port        => node[:deployment][:nginx_port],
        :port               => node[:deployment][:port],
        :project_fqdn       => node[:project_fqdn],
        :non_odi_hostname   => node[:non_odi_hostname],
        :catch_and_redirect => node[:catch_and_redirect],
        :default            => node[:deployment][:default_vhost],
        :static_assets      => node[:deployment][:static_assets]
    )
    action :create
  end

#  Dir["#{vhosts_dir}/*"].each do |vh|
#    puts '================================='
#    puts vh
#    puts '================================='

#    f = File.open "/tmp/derp", "w"
#    f.write vh
#    f.write "\n"
#    f.write File.basename vh
#    f.write "\n"
#    f.close
#
  link "/etc/nginx/sites-enabled/%s" % [
      File.basename(vh)
  ] do
    to vh
  end
#  end
end
