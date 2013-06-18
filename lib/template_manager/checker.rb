require 'zip/zip'
require 'hashie'
require 'yaml'

module TemplateManager
  module Checker
    class CheckFailed < StandardError; end

    def check(file_path, &block)
      zip_file = _read_zip(file_path)
      begin
        _check_integrity zip_file, &block
        zip_file.close
      rescue StandardError => e
        zip_file.close
        raise e
      end
    end

    private

    def _read_zip(file)
      Zip::ZipFile.open(file, Zip::ZipFile::CREATE)
    end

    def _check_integrity(zip_file)
      info = Hashie::Mash.new(YAML.load(zip_file.read('template.yml'))).template
      raise CheckFailed, 'template.yml的信息不完整' if info.name.nil? or
          info.version.nil? or info.type.nil? or
          info.screen_name.nil? or info.summary.nil?

      check_paths = []
      info.edit_paths.each do |path|
        check_paths << _get_path(path)
      end unless info.edit_paths.nil?

      info.skim_paths.each do |path|
        check_paths << _get_path(path)
      end unless info.skim_paths.nil?

      _check_paths zip_file, check_paths
      yield info if block_given?
    end

    def _get_path(path_info)
      case
        when path_info.is_a?(String)
          path_info
        when path_info.is_a?(Hashie::Mash)
          path_info.path
        else
          nil
      end
    end

    def _check_paths(zip_file, paths)
      has_edit_view = false
      has_skim_view = false
      zip_file.each do |entry|
        break if has_edit_view and has_skim_view and paths.size == 0
        unless entry.name.match(/^edit\/view\/content[\w.]+/).nil?
          has_edit_view = true
          next
        end
        unless entry.name.match(/^skim\/view\/content[\w.]+/).nil?
          has_skim_view = true
          next
        end

        if paths.include? entry.name
          paths.delete entry.name
        end
      end

      raise CheckFailed, "#{paths.join ','} 不存在" if paths.size != 0
      raise CheckFailed, '编辑模式中的页面不存在' unless has_edit_view
      raise CheckFailed, '浏览模式中的页面不存在' unless has_skim_view
    end
  end
end