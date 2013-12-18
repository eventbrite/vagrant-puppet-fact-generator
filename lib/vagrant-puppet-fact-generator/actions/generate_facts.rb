module VagrantPlugins
  module PuppetFactGenerator
    class Action
      class GenerateFacts

        def initialize(app, env)
          @app = app
          @env = env
          @puppet_fact_generator = @env[:global_config].puppet_fact_generator

          provisioner = @env[:global_config].vm.provisioners[0]
          @puppet_config = provisioner ? provisioner.config: nil
          @vagrant_git_commiter_details = '.VAGRANT_GIT_COMMITER_DETAILS'
        end

        def call(env)
          if @puppet_config and @puppet_fact_generator.facts
            @puppet_fact_generator.facts.each_pair { |k, v| @env[:ui].success "Creating fact #{k} => #{v}" }
            @puppet_config.facter = @puppet_config.facter.merge(@puppet_fact_generator.facts)
          end
          @app.call(env)
        end

      end
    end
  end
end
