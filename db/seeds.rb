# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# rubocop:disable Rails/Output

# Users seeding
print("\nStarts users seeding\n")
3.times do
  FactoryBot.create(:user)
  print '.'
end
puts("\nPosts are created!")

# Projects seeding
print("\nStarts projects seeding\n")
5.times do
  FactoryBot.create(:project, user: User.all.sample)
  print '.'
end
puts("\nPosts are created!")

# Tasks seeding
print("\nStarts tasks seeding\n")
15.times do
  FactoryBot.create(:task, project: Project.all.sample)
  print '.'
end
puts("\nPosts are created!")
# rubocop:enable Rails/Output
