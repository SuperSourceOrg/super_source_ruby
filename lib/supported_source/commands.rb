require 'erb'
require 'json'
require 'fileutils'
require 'io/console'

module SupportedSource
  class Commands
    def self.command_mode?
      SupportedSource::operating_mode == 'command'
    end

    def self.prompt_choices(choices = [])
      while true
        print "Enter a number 0 - #{ choices.length - 1}\n"
        choices.each_with_index do |choice, idx|
          choice_name = choice.is_a?(String) ? choice : choice[1]
          print "#{ idx }: #{ choice_name }\n"
        end
        choice = STDIN.gets.strip.to_i
        if 0 <= choice && choice < choices.length
          selected = choices[choice]
          return selected.is_a?(String) ? selected : selected[0]
        end
      end
    end

    def self.prompt_confirmation_token(to_email)
      token = ''
      while token.length < 4
        puts "Enter the confirmation token that was sent to #{ to_email }: (or enter 'resend')"
        token = STDIN.gets.strip
        if token.length < 4
          puts "Sorry, #{ token } is not a valid confirmation token."
        end
      end
      token
    end

    def self.prompt_email
      email = ''
      while !Util.is_email?(email)
        puts "Enter your email address:"
        email = STDIN.gets.strip
        if !Util.is_email?(email)
          puts "Sorry, #{ email } is not a valid email address."
        end
      end
      email
    end

    def self.acceptable_commands
      ['info', 'logout', 'login', 'update', 'whoami']
    end

    def self.update
      Updater.update
    end

    def self.whoami
      user = User.current_user
      puts user ? user.email : nil
    end

    def self.logout
      User.log_out!
    end

    def self.login
      email = Commands.prompt_email

      without_password_response = Util.http_post("#{ SupportedSource.supso_api_root }sign_in_request_token_api", email: email)
      if !without_password_response['success']
        puts without_password_response['reason']
        return
      end

      if without_password_response['confirmation_token_sent']
        succeeded = false
        while !succeeded
          token = Commands.prompt_confirmation_token(email)
          succeeded, reason = User.log_in_with_confirmation_token!(email, token)
          if !succeeded && reason
            puts reason
          end
        end
      else
        succeeded = false
        while !succeeded
          puts "Enter your password:"
          password = STDIN.noecho(&:gets).chomp
          succeeded, reason = User.log_in_with_password!(email, password)
          if !succeeded && reason
            puts reason
          end
        end
      end

      puts "Successfully signed in as #{ email }."
    end

    def self.info
      Util.require_all_gems!
      if Project.projects.length == 0
        puts "0 projects using Supported Source."
      else
        puts "#{ Project.projects.length } #{ Util.pluralize(Project.projects.length, 'project') } using Supported Source.\n"
        Project.projects.each do |project|
          project.puts_info
        end
      end
    end

    def self.route_command(args)
      SupportedSource::operating_mode = 'command'

      if args.length == 0
        return SupportedSource::Commands.help
      end

      command = args[0]
      if !Commands.acceptable_commands.include?(command)
        puts "No such command: #{ command }"
        return SupportedSource::Commands.help
      end

      begin
        SupportedSource::Commands.public_send(command, *args[1..-1])
      rescue => err
        SupportedSource::Logs.error(err)
      end
    end

    def self.help
      puts "Usage: supso command"
      puts "Commands: #{ acceptable_commands.sort.join(' ') }"
    end
  end
end
