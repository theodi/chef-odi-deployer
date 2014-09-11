define :precompile_assets, :params => {} do
  user = params[:user]
  cwd = params[:cwd]

  script 'Precompiling assets' do
    interpreter 'bash'
    cwd cwd
    user user
    environment "PATH" => user_path(user)
    code <<-EOF
      /home/#{user}/.rbenv/shims/bundle exec rake assets:precompile
    EOF
  end
end
