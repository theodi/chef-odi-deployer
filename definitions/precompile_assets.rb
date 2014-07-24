define :precompile_assets, :params => {} do
  user = params[:user]
  cwd = params[:cwd]

  script 'Precompiling assets' do
    interpreter 'bash'
    cwd cwd
    user user
    code <<-EOF
      rake assets:precompile
    EOF
  end
end
