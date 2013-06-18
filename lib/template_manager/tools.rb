module TemplateManager
  module Tools
    # 如果路径不存在就创建
    def check_path(path)
      FileUtils.rm_r path if File.exist? path
      dir = File.dirname(path)
      FileUtils.mkdir_p dir unless File.exist? dir
    end
  end
end