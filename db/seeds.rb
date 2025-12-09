# Create a department

puts "Creating Department..."
it_dept = Department.find_or_create_by!(name: 'IT', description: 'Information Technology')
hr_dept = Department.find_or_create_by!(name: 'HR', description: 'Human Recources')

# Create an Admin User

puts "Creating Admin User..."
admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
    u.password = 'password123'
    u.password_confirmation = 'password123'
    u.full_name = 'System Administrator'
    u.role = :admin
    u.department = it_dept
end

puts "Seed finished! You can login with: admin@example.com / password123"