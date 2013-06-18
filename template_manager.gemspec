# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'template_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "template_manager"
  spec.version       = TemplateManager::VERSION
  spec.authors       = ["Gen"]
  spec.email         = ["z.rz2323721@gmail.com"]
  spec.description   = %q{管理MyBoKa的模板文件}
  spec.summary       = %q{管理MyBoKa的模板文件}
  spec.license       = "MIT"

  arr = ['lib/template_manager.rb']
  Dir.foreach('lib/template_manager'){|f| arr << "lib/template_manager/#{f}" unless ['.','..'].include? f}
  spec.files         = arr
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'uuidtools'
  spec.add_dependency 'rubyzip'
  spec.add_dependency 'hashie'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
