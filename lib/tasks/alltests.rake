namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = Dir['spec/*/**/*_spec.rb'].reject{ |f| f['/features'] }
  end

  RSpec::Core::RakeTask.new(:feature) do |t|
    t.pattern = "spec/features/**/*_spec.rb"
  end

  RSpec::Core::RakeTask.new(:all_without_stripe) do |t|
    t.pattern = Dir['spec/*/**/*_spec.rb'].reject{ |f| f['/features/charges_features_spec.rb'] }
  end

  RSpec::Core::RakeTask.new(:only_stripe) do |t|
    t.pattern = "spec/features/charges_features_spec.rb"
  end
end