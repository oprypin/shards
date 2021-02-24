module Shards
  module Script
    class Error < Error
    end

    def self.run(path, command, script_name, dependency_name)
      Dir.cd(path) do
        output = IO::Memory.new
        {% if flag?(:win32) %}
          if chopped = command.lchop?("./")
            command = ".\\#{chopped}"
          end
          command = "cmd /c #{command}"
        {% end %}
        status = Process.run(command, shell: true, output: output, error: output)
        raise Error.new("Failed #{script_name} of #{dependency_name} on #{command}:\n#{output.to_s.rstrip}") unless status.success?
      end
    end
  end
end
