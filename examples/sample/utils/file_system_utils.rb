# frozen_string_literal: true

# FileSystemUtils.
module FileSystemUtils

  def file_exist?(name)
    File.exist?(path(name))
  end

  def create_file(name)
    File.open(path(name), 'w')
  end

  def remove_file(name)
    File.delete(path(name))
  end

  def path(name)
    File.join(File.dirname(__FILE__), "../files/#{name}")
  end

end
