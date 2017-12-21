# frozen_string_literal: true

# FileSystemUtils.
module FileSystemUtils

  def file_exist?(name)
    path = File.join(File.dirname(__FILE__), "../files/#{name}")
    File.exist?(path)
  end

end
