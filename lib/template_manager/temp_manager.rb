require 'uuidtools'

module TemplateManager
  class TempManager
    def initialize(path)
      @temp_path = path
    end

    def temp_path
      @temp_path
    end

    #新建一个缓存用的文件夹,如果给了block会在block执行完后删除文件夹
    def new_folder(auto_remove = true)
      path = nil
      while path.nil?
        uuid = UUIDTools::UUID::random_create.to_s
        path = "#{temp_path}/#{uuid}"
        path = nil if File.exist? path
      end

      FileUtils.mkdir_p path
      if block_given?
        begin
          yield path
          FileUtils.rm_r path if auto_remove
        rescue StandardError => e
          FileUtils.rm_r path if auto_remove
          raise e
        end
      else
        path
      end
    end

    def clear
      Dir.foreach(temp_path) do |f|
        FileUtils.rm_r "#{temp_path}/#{f}" unless ['.', '..'].include? f
      end
    end
  end
end