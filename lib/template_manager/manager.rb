require 'template_manager/temp_manager'
require 'template_manager/checker'
require 'template_manager/decompression'
require 'template_manager/tools'

module TemplateManager
  # 管理实体类
  class Manager
    include Checker
    include Tools
    # options 传入参数
    # :path 保存模板文件的位置,必须有
    # :zip_path 存放压缩文件的位置, 默认 :path + 'zip'
    # :temp_path 暂存文件的位置,默认 :path + 'template_manager_temp'
    # :static_path 静态文件的放置位置,默认 :path + 'template_manager_static'
    # :net_address 网络网址，用于别的计算机获得模板文件

    def initialize(options)
      raise "Can't find :path in the options" if options[:path].nil?
      default = {
          temp_path: "#{options[:path]}/template_manager_temp",
          static_path: "#{options[:path]}/template_manager_static",
          zip_path: "#{options[:path]}/zip"
      }
      @options = default.merge options

      @temp_manager = TempManager.new(@options[:temp_path])
    end

    def zip_path
      @options[:zip_path]
    end

    def static_path
      @options[:static_path]
    end

    def <<(file)
      @temp_manager.new_folder do |path|
        temp_path = "#{path}/file.zip"
        File.open temp_path ,'wb' do |the_file|
          the_file.write file.read
        end
        check temp_path do |info|
          path = "#{zip_path}/#{info.name}-#{info.version}.zip"
          check_path path
          FileUtils.cp temp_path, path
        end
      end
    end

    def get(name, version)
      path = "#{zip_path}/#{name}-#{version}.zip"
      path = nil unless File.exist? path
      path
    end

    def extend_static(name, version)
      path = get name, version
      unless path.nil?
        Decompression.statics(path, static_path)
      end
    end
  end
end