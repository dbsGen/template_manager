require '../lib/template_manager'

class ManagerTest
  def test
    manager = TemplateManager::Manager.new path: File.dirname(__FILE__)
    File.open '/home/gen/Project/default_blog.zip', 'r' do |file|
      manager << file
    end

    manager.extend_static('default_blog', 0.1)
  end
end

ManagerTest.new.test