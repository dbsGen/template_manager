require 'zip/zip'
require 'template_manager/tools'

module TemplateManager
  module Decompression
    class << self
      include Tools
      def statics(file_path, des)
        Zip::ZipFile.open file_path, Zip::ZipFile::CREATE do |zip_file|
          zip_file.each do |entry|
            if entry.name[/^\/?edit\/view\//].nil? and
               entry.name[/^\/?skim\/view\//].nil? and
               entry.name[/^\/?template.yml$/].nil?
              p = "#{des}/#{entry.name}"
              check_path p
              entry.extract(p)
            end
          end
        end
      end

      def actives(file_path, des)
        Zip::ZipFile.open file_path, Zip::ZipFile::CREATE do |zip_file|
          zip_file.each do |entry|
            unless entry.name[/^\/?edit\/view\//].nil? and
                   entry.name[/^\/?skim\/view\//].nil? or
                   !entry.name[/^\/?template.yml$/].nil?
              p = "#{des}/#{entry.name}"
              check_path p
              entry.extract(p)
            end
          end
        end
      end
    end
  end
end