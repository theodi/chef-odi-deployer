define :bundlify, :params => {} do
  cwd = params[:name]
  user = params[:user]
  depot = params[:bundler_depot]

  script 'Bundling the gems' do
    interpreter 'bash'
    cwd cwd
    user user
    environment "PATH" => user_path(user)
    code <<-EOF
      bundle install \
        --without=development test \
        --quiet
    EOF
  end
end
