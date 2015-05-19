namespace :admin do
  desc 'Set user as admin'
  task :set, [ :username_or_email ] => [ :environment ] do |t, args|
    user = User.find_for_database_authentication(login: args.username_or_email)
    raise 'User not found' if user.nil?
    if user.update_attribute(:admin, true)
      puts "Updated #{user.username} successfully."
    else
      puts 'Update failed.'
    end
  end

  desc 'Add admin user'
  task :add, [ :username, :email, :password ] => [ :environment ] do |t, args|
    params = { username: args.username, email: args.email, password: args.password, admin: true }
    user = User.create!(params)
    puts "Added #{user.username} successfully."
  end
end
