# namespace :spec do
#   RSpec::Core::RakeTask.new(:unit) do |t|
#     t.pattern = Dir['spec/models/*_spec.rb'].reject{ |f| f['/features'] }
#   end

#   RSpec::Core::RakeTask.new(:feature) do |t|
#     t.pattern = "spec/features/*_spec.rb"
#   end

#   RSpec::Core::RakeTask.new(:search) do |t|
#     t.pattern = "spec/features/search_feature_spec.rb"
#   end  

#   RSpec::Core::RakeTask.new(:projects) do |t|
#     t.pattern = "spec/features/projects_feature_spec.rb"
#   end

#   RSpec::Core::RakeTask.new(:donations) do |t|
#     t.pattern = "spec/features/donations_feature_spec.rb"
#   end

#   RSpec::Core::RakeTask.new(:blog) do |t|
#     t.pattern = "spec/features/blog_feature_spec.rb"
#   end

#   RSpec::Core::RakeTask.new(:timer) do |t|
#     t.pattern = "spec/features/timer_feature_spec.rb"
#   end

#   RSpec::Core::RakeTask.new(:only_stripe) do |t|
#     t.pattern = "spec/features/charges_features_spec.rb"
#   end

#   RSpec::Core::RakeTask.new(:only_timer) do |t|
#     t.pattern = "spec/features/timer_features_spec.rb"
#   end

#   RSpec::Core::RakeTask.new(:all_without_stripe) do |t|
#     t.pattern = Dir['spec/*/**/*_spec.rb'].reject{ |f| f['/features/charges_features_spec.rb'] }
#   end
  
#   RSpec::Core::RakeTask.new(:followers) do |t|
#     t.pattern = "spec/features/followers_feature_spec.rb"
#   end

#   RSpec::Core::RakeTask.new(:users) do |t|
#     t.pattern = "spec/features/users_feature_spec.rb"
#   end

# end