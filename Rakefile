# if there are any packages that don't have the right targets or are simply
# missing a rakefile, put them here.
PACKAGE_EXCLUSIONS = [ "libxml-feed" ]

packages = []

FileList["./*"].each do |x|
    next unless File.directory? x
    packages.push File.basename(x).to_sym unless PACKAGE_EXCLUSIONS.include? File.basename(x)
end

packages.each do |package|
    namespace package do
        task :default => [ :test, :rdoc, :package ]
        task :clean   => [ :clobber_package, :clobber_rdoc ] 
        task :distclean => [ :clean ]

        %w(package rdoc test clobber_package clobber_rdoc).each do |target|
            task target.to_sym do
                chdir package.to_s
                sh "rake #{target}"
                chdir ".."
            end
        end
    end
end

task :default => %w(test-all build-all)
task :showpkgs do 
    require 'pp'
    pp packages
end

task "build-all" => packages.collect { |x| [x, "default"].join(":") }
task "test-all"  => packages.collect { |x| [x, "test"].join(":") }
task "clean-all" => packages.collect { |x| [x, "clean"].join(":") }
task "doc-all"   => packages.collect { |x| [x, "doc"].join(":") }
