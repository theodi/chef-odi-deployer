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
    code <<-EOF
      echo "PATH=/home/#{user}/.rbenv/shims:/usr/local/bin:/usr/bin:/bin" > #{root_dir}/shared/path_env
      /home/#{user}/.rbenv/shims/bundle exec foreman export \
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

###define :foremanise, :params => {} do
###  template "%s/.foreman" % [
###      params[:cwd]
###  ] do
###    source "dotforeman.erb"
###    variables(
###        :port => params[:port],
###        :app => params[:name],
###        :user => params[:user]
###    )
###  end
###
###  script 'Generate foreman path environment' do
###    interpreter 'bash'
###    cwd params[:cwd]
###    user params[:user]
###    code <<-EOF
###      RUBY="#{node[:rvm][:user_installs].select { |h| h[:user] == user }[0][:default_ruby]}"
###      echo "PATH=/home/#{user}/.rvm/gems/ruby-${RUBY}@global/bin:/home/#{user}/.rvm/rubies/ruby-${RUBY}/bin" > /tmp/path_env
###    EOF
###  end
###
###  script 'Start Me Up' do
###    interpreter 'bash'
###    cwd params[:cwd]
###    user params[:user]
###    code <<-EOF
###        RUBY="#{node[:rvm][:user_installs].select { |h| h[:user] == user }[0][:default_ruby]}"
###        BINPATH="/home/#{user}/.rvm/bin/:/home/#{user}/.rvm/rubies/ruby-${RUBY}/bin/"
###        PATH=${BINPATH}:${PATH}
###        export rvmsudo_secure_path=1
###        rvmsudo bundle exec foreman export upstart /etc/init -e #{params[:cwd]}/.env,/tmp/path_env
###    EOF
###  end
###end
