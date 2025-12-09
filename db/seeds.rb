# Create a department

puts "Creating Department..."
it_dept = Department.find_or_create_by!(name: 'IT', description: 'Information Technology')
hr_dept = Department.find_or_create_by!(name: 'HR', description: 'Human Recources')

# Create an Admin User

puts "Creating Admin User..."
admin = User.find_or_create_by!(email: 'cephas@administrator.com') do |u|
    u.password = 'Kc02579@.'
    u.password_confirmation = 'Kc02579@.'
    u.full_name = 'Cephas Anane'
    u.role = :admin
    u.department = hr_dept
end

puts "Seed finished! You can login with: cephas@administrator.com / Kc02579@."