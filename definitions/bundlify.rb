define :bundlify, :params => {} do
  cwd = params[:name]
  user = params[:user]
  depot = params[:bundler_depot]

  script 'Bundling the gems' do
    interpreter 'bash'
    cwd cwd
    user user
    code <<-EOF
      /home/#{user}/.rbenv/shims/bundle install \
        --without=development test \
        --quiet
    EOF
  end
end
