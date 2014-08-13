define :make_vhosts, :params => {} do
  vhosts_dir = "%s/vhosts" % [
    params[:cwd]
  ]

  vh = "%s/%s" % [
      vhosts_dir,
      params[:fqdn]
  ]

  directory vhosts_dir do
    action :create
    owner params[:user]
  end

  template vh do
    source "vhost.erb"
    variables(
        :servername         => node['git_project'],
        :listen_port        => node['deployment']['nginx_port'],
        :port               => node['deployment']['port'],
        :fqdn               => params[:fqdn],
        :catch_and_redirect => node['catch_and_redirect'],
        :default            => node['deployment']['default_vhost'],
        :static_assets      => node['deployment']['static_assets'],
        :assets_allow_origin => node['deployment']['assets_allow_origin']
    )
    action :create
  end

  link "/etc/nginx/sites-enabled/%s" % [
      File.basename(vh)
  ] do
    to vh
  end
#  end
end
