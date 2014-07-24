define :post_deploy_tasks, :params => {} do
  commands = params[:name]
  user = params[:user]
  cwd = params[:cwd]

  (commands || []).each do |command|
    script command do
      interpreter 'bash'
      cwd cwd
      user user
      code <<-EOF
        RAILS_ENV=#{node[:deployment][:rack_env]} #{command}
      EOF
    end
  end
end
