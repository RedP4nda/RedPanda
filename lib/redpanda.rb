require "redpanda/version"
require 'highline'
require 'shellwords'

module RedPanda
    def self.rename_project(project_name)
        path = project_name.shellescape
        rename_files_command = "find #{path} -name 'RedPanda_TEMPLATE.xc*' -print0 | xargs -0 rename --subst-all 'RedPanda_TEMPLATE' #{path} > /dev/null"
        rename_strings_command = "ack --literal --files-with-matches 'RedPanda_TEMPLATE' #{path} --print0 | xargs -0 sed -i '' 's/RedPanda_TEMPLATE/#{project_name}/g' > /dev/null"

        puts "Replacing files and configurations..."
        success = system(rename_files_command)
        success = system(rename_files_command)
        unless success
            puts "command failed with status #{$?.exitstatus}"
            exit
        end
        success = system(rename_strings_command)
        unless success
            puts "command failed with status #{$?.exitstatus}"
            exit
        end
    end

    def self.update_bundle_id(new_bundle_id, project_name)
        path = project_name.shellescape
        redpanda_bundle_id = "com.redpanda.bundleid"
        rename_bundle_id_command = "ack --literal --files-with-matches '#{redpanda_bundle_id}' #{path} --print0 | xargs -0 sed -i '' 's/#{redpanda_bundle_id}/#{new_bundle_id}/g'"

        success = system(rename_bundle_id_command)
        unless success
            puts "command failed with status #{$?.exitstatus}"
            exit
        end
    end

    def self.copy_project(path, name)
        mkdir_command = "mkdir #{name}"
        copy_command = "cp -R #{path}/ #{name}"
        puts "Copying new RedPanda Project from Template..."
        if !Dir.glob('directory/{*,.*}').empty?
            puts "A directory named #{path} already exists and is not empty"
            exit
        end
        success = system(mkdir_command)
        unless success
            puts "command failed with status #{$?.exitstatus}"
            exit
        end
        puts copy_command
        success = system(copy_command)
        unless success
            puts "command failed with status #{$?.exitstatus}"
            exit
        end

    end

    def self.post_install_action(project_name)
        path = project_name.shellescape
        puts "Running pod install..."
        success = system("cd #{path} && pod install")
        unless success
            puts "command failed with status #{$?.exitstatus}"
            exit
        end
        success = system("cd #{path} && fastlane redpanda_hello")
        unless success
            puts "command failed with status #{$?.exitstatus}"
            exit
        end
    end

    def self.create_project(cli)
        cli.say("Starting Project Creation Process")
        project_name = cli.ask("What project/application name should be used ?") { |q| q.validate = /\A[a-zA-Z0-9]+\Z/ }
        project_bundle_id = cli.ask("What bundle id should be used for the project ?") { |q| q.validate = /\A[a-zA-Z0-9.]+\Z/ }

        puts "Creating new project with name: #{project_name}"
        redpanda_gem_path = File.expand_path '..', File.dirname(__FILE__)
        template_project_path = redpanda_gem_path + "/Template"
        puts template_project_path
        copy_project(template_project_path, project_name)
        rename_project(project_name)
        update_bundle_id(project_bundle_id, project_name)

        puts "Running post install actions..."
        post_install_action(project_name)

    end

    def self.exit_program(cli)
        cli.say("Exiting...")
        exit
    end

    def self.check_installed_commands
      unless system("which rename > /dev/null 2>&1") then
        puts "rename is required for redpanda to run, please consider installing rename with homebrew: 'brew install rename'"
      end
      unless system("which ack > /dev/null 2>&1") then
        puts "rename is required for redpanda to run, please consider installing rename with homebrew: 'brew install ack'"
      end
    end

    def self.menu
        check_installed_commands
        cli = HighLine.new
        cli.choose do |menu|
            menu.prompt = "Actions:"
            menu.choice(:create) { create_project(cli) }
            menu.choices(:exit) { exit_program(cli) }
        end
    end
end
