define :foremanise, :params => {} do
  name = params[:name]
  user = params[:user]
  cwd = params[:cwd]
  root_dir = params[:root_dir]
  port = params[:port]


  %w{ log run }.each do |subdir|
    script 'Make dirs for Foreman' do
      interpreter 'bash'
      user 'root'
      code <<-EOF
        mkdir -p /var/#{subdir}/#{name}
        chown #{user} /var/#{subdir}/#{name}
      EOF
    end
  end

  script 'Generate startup scripts with Foreman' do
    interpreter 'bash'
    cwd cwd
    user user
    environment "PATH" => user_path(user)
    code <<-EOF
      echo "PATH=#{user_path(user)}" > #{root_dir}/shared/path_env
      bundle exec foreman export \
        -a #{name} \
        -u #{user} \
        -t config/foreman \
        -p #{port} \
        -e #{cwd}/.env,#{root_dir}/shared/path_env \
        upstart /tmp/init
    EOF
  end

  script 'Copy startup scripts into the right place' do
    interpreter 'bash'
    user 'root'
    code <<-EOF
      mv /tmp/init/* /etc/init/
    EOF
  end
end
